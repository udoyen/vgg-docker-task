import unittest
from myproject import app


class TestBasic(unittest.TestCase):

    def setUp(self):
        app.testing = True
        self.app = app.test_client()

    def test_homepage(self):
        response = self.app.get('/', follow_redirects = True)
        self.assertEqual(response.status_code, 200)


if __name__ == '__main__':
    unittest.main()
