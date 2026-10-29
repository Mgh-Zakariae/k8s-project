from app import app
from unittest.mock import Mock

app.secret_key = "test_74298dsd4373"

def test_homepage():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 302
    assert 'login' in response.headers["Location"]
    
def test_loginGet():
    client = app.test_client()
    resp = client.get('/login')
    assert resp.status_code == 200
    
def test_loginPost():
    client = app.test_client()
    resp = client.post('/login', data={'username': 'tester'})
    assert resp.status_code == 302
    assert resp.headers['Location'].endswith('/')
    assert 'session=' in resp.headers['Set-Cookie']
    
def test_get_tasks(monkeypatch):
    fake_cache = Mock()
    fake_cache.lrange.return_value = ["task_1", "task_2"]
    
    monkeypatch.setattr('app.cache', fake_cache)
    
    client = app.test_client()
    with client.session_transaction() as session:
        session['username'] = "0xmg"
    resp = client.get('/')
    assert resp.status_code == 200
    assert b'tasks' in resp.data
    assert b'task_1' in resp.data
    assert b'task_2' in resp.data
    
def test_add_task(monkeypatch):
    fake_cache = Mock()
    monkeypatch.setattr("app.cache", fake_cache)
    
    client = app.test_client()
    with client.session_transaction() as session:
            session['username'] = "0xmg"
    resp = client.post('/', data={"name": "test task"})
    assert resp.status_code == 302
    assert resp.headers['Location'].endswith('/')
    
    # Verify that the backend sent the expected data to Redis
    fake_cache.rpush.assert_called_once_with('0xmg:tasks', 'test task')