output "api_endpoint" {
  value = "${aws_api_gateway_rest_api.foo_api.execution_arn}/default/foo"
}
