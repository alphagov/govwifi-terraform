terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.replication]
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "main" {}

data "aws_region" "replication" {
  provider = aws.replication
}
