### Simply flask application deployed using nginx (reverse proxy) and containerized using dockerfile

Build:
- docker build -t your_name:v1 .

Run:
- docker run --name any_name -p 5000:5000 your_name:v1