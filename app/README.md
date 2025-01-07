To build the Docker image:
```sh
docker build -t app .
docker run -p 3000:3000 app
```

Verify:
```sh
curl http://localhost:3000/health
```

Preload the app image into LocalStack’s Docker environment:
```sh
docker tag app:latest localstack/app:latest
docker save app | docker-compose exec -T localstack docker load
```
