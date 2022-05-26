terraform {
  required_version = "~> 1.1.8"

  backend "s3" {
    bucket = "govwifi-tools-tfstate"

    key    = "govwifi-terraform-tfstate"
    region = "eu-west-2"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

module "ci" {
  providers = {
    aws = aws.main
  }

  source        = "../../govwifi-ci"
  env           = "staging"
  env_name      = "staging"
  env_subdomain = local.env_subdomain

  aws_account_id         = local.aws_account_id
  aws_region_name        = var.aws_region_name
  aws_region             = var.aws_region
  app_names              = ["user-signup-api"]

}

# provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
# }

# module "tfstate" {
#   providers = {
#     aws             = aws.london
#     aws.replication = aws.dublin
#   }
#
#   source   = "../../new-terraform-state"
#   env_name = local.env_name
# }
