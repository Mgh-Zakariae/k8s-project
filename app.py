import os
import time
import redis
from flask import Flask, request, redirect, url_for, render_template_string, session
from dotenv import load_dotenv

app = Flask(__name__)


load_dotenv()

app.secret_key = os.getenv("SECRET_KEY")

REDIS_HOST = os.getenv("REDIS_HOST")
REDIS_PORT = os.getenv("REDIS_PORT")
DEBUG = os.getenv("DEBUG").lower() == "true"

cache = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        session['username'] = username
        return redirect(url_for('hello'))
    return """
        <h1>Login</h1>
        <form method='POST'>
            <input name='username' type='text'>
            <button type='submit'>Login</button>
        </form>
        """


@app.route('/', methods=['POST', 'GET'])
def hello():
    if 'username' not in session:
        return redirect(url_for('login'))
    user = session['username']
    if request.method == 'GET':
        tasks = cache.lrange(f"{user}:tasks", 0, -1)
        template = """
                <h1>Hello</h1>\n
                <p>Let's store our tasks</p>\n
                <form method='POST'>
                    <input name='name' type='text'>
                    <button type='submit'>Submit</button>
                </form>
                <h1>Your Tasks</h1>
                <div>
                    {% if not tasks[0] %}
                        <h4 style='margin-left:35px;'>add something</h4>
                    {% else %}
                        <ul>
                            {% for t in tasks %}
                                <li>{{t}}</li>
                            {% endfor %}
                        </ul>
                    {% endif %}
                </dvi>
                """
        
        return render_template_string(template, tasks=tasks)
    elif request.method == 'POST':
        task_name = request.form['name']
        cache.rpush(f"{user}:tasks", task_name)
        
        return redirect(url_for("hello"))
    
@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('login'))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=DEBUG)