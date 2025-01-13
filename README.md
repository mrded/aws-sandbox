# trip-planner

```sh
brew install localstack terraform
export AWS_ACCESS_KEY_ID="mock_access_key"
export AWS_SECRET_ACCESS_KEY="mock_secret_key"

(cd terraform; terraform init; terraform apply)
```

From the project root directory, start LocalStack using:
```sh
# GATEWAY_LISTEN=3000 localstack start
# LOCALSTACK_GATEWAY_LISTEN=3000 localstack start
# GATEWAY_PORT=3000 localstack start
docker-compose up -d
```

Confirm LocalStack is running:
```sh
curl http://localhost:4566/health
```

Validate the deployment:
TODO: why is this empty?
```sh
aws apigateway get-rest-apis --endpoint-url=http://localhost:4566
aws lambda list-functions --endpoint-url=http://localhost:4566
```

to test:
```sh
# eg: api_endpoint = "arn:aws:execute-api:us-east-1::d4ibxvgqds/default/foo"
curl http://localhost:4566/restapis/d4ibxvgqds/default/_user_request_/foo
```

Manually create a lambda function:
```sh
aws lambda create-function \
  --function-name foo-lambda \
  --runtime nodejs18.x \
  --role arn:aws:iam::000000000000:role/lambda_exec_role \
  --handler index.handler \
  --zip-file fileb://lambdas/foo-lambda.zip \
  --endpoint-url=http://localhost:4566
```
