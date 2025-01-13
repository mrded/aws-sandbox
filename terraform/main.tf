terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  endpoints {
    lambda     = "http://localhost:4566"
    apigateway = "http://localhost:4566"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "foo_lambda" {
  function_name    = "foo-lambda"
  runtime          = "nodejs18.x"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  filename         = "${path.module}/../lambdas/foo-lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/foo-lambda.zip")

}

resource "aws_api_gateway_rest_api" "foo_api" {
  name = "foo-api"
}

resource "aws_api_gateway_resource" "foo_resource" {
  rest_api_id = aws_api_gateway_rest_api.foo_api.id
  parent_id   = aws_api_gateway_rest_api.foo_api.root_resource_id
  path_part   = "foo"
}

resource "aws_api_gateway_method" "foo_method" {
  rest_api_id   = aws_api_gateway_rest_api.foo_api.id
  resource_id   = aws_api_gateway_resource.foo_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "foo_integration" {
  rest_api_id             = aws_api_gateway_rest_api.foo_api.id
  resource_id             = aws_api_gateway_resource.foo_resource.id
  http_method             = aws_api_gateway_method.foo_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.foo_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "foo_deployment" {
  rest_api_id = aws_api_gateway_rest_api.foo_api.id
  depends_on  = [aws_api_gateway_integration.foo_integration]
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.foo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.foo_api.execution_arn}/*"
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = "default"
  rest_api_id   = aws_api_gateway_rest_api.foo_api.id
  deployment_id = aws_api_gateway_deployment.foo_deployment.id
}
