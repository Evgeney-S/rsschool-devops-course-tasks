import unittest
from main import app

class FlaskAppTests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_health(self):
        response = self.client.get('/health')
        self.assertEqual(response.status_code, 200)
        self.assertIn('OK', response.data.decode('utf-8'))

    def test_add(self):
        response = self.client.get('/add')
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
