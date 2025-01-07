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

Make sure the `/app` Docker image is already built and available. Ensure this image is pushed to a Docker registry accessible from the EC2 instance or preloaded into the LocalStack Docker environment.

Apply the Terraform configuration from `/terraform`

Confirm the EC2 instance is running with:

```sh
aws --endpoint-url=http://localhost:4566 ec2 describe-instances
```
