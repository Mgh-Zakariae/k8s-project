from app import app

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
    app.secret_key = "test_74298dsd4373"
    client = app.test_client()
    resp = client.post('/login', data={'username': 'tester'})
    assert resp.status_code == 302
    assert resp.headers['Location'].endswith('/')
    assert 'session=' in resp.headers['Set-Cookie']
    # resp = client.post('/login', data={'username': 'tester'}, follow_redirects=True)
    # assert b'tasks' in resp.data
    
# Add functions to test feature of tasks 