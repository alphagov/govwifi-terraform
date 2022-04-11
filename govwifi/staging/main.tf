terraform {
  required_version = "~> 1.0.11"

  backend "s3" {
    bucket = "govwifi-staging-tfstate-eu-west-2"

    key    = "staging-tfstate"
    region = "eu-west-2"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "tfstate" {
  providers = {
    aws             = aws.london
    aws.replication = aws.dublin
  }

  source   = "../../new-terraform-state"
  env_name = local.env_name
}
