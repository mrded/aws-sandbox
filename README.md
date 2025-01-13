# trip-planner

```sh
brew install localstack terraform
export AWS_ACCESS_KEY_ID="mock_access_key"
export AWS_SECRET_ACCESS_KEY="mock_secret_key"

(cd terraform; terraform init; terraform apply)
```

From the project root directory, start LocalStack using:
```sh
docker-compose up -d
```

Confirm LocalStack is running:
```sh
curl http://localhost:4566/health
```

to test:
```sh
# eg: api_endpoint = "arn:aws:execute-api:us-east-1::d4ibxvgqds/default/foo"
curl http://localhost:4566/restapis/d4ibxvgqds/default/_user_request_/foo
```
