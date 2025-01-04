terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  endpoints {
    ec2 = "http://localhost:4566"
  }
}

resource "aws_security_group" "nodejs_sg" {
  name        = "nodejs-service-sg"
  description = "Allow inbound traffic for Node.js service"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nodejs_ec2" {
  ami             = "ami-localstack" # Placeholder for LocalStack-compatible AMI
  instance_type   = var.instance_type
  security_groups = [aws_security_group.nodejs_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              docker run -d -p 3000:3000 app 
              EOF

  tags = {
    Name = "NodeJSService"
  }
}
