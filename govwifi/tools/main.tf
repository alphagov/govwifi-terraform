# module "tfstate" {
#   providers = {
#     aws = aws.main
#   }
#
#   source             = "../../terraform-state"
#   product_name       = local.product_name
#   env_name           = local.env_name
#   aws_account_id     = local.aws_account_id
#   aws_region_name    = var.aws_region_name
#   backup_region_name = var.backup_region_name
#
#   # TODO: separate module for accesslogs
#   accesslogs_glacier_transition_days = 7
#   accesslogs_expiration_days         = 30
# }

terraform {
  required_version = "~> 1.1.8"

  backend "s3" {
    # Interpolation is not allowed here.
    #bucket = "${lower(local.product_name)}-${lower(local.env_name)}-${lower(var.aws_region_name)}-tfstate"
    #key    = "${lower(var.aws_region_name)}-tfstate"
    #region = "${var.aws_region}"
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

provider "aws" {
  alias  = "main"
  region = var.aws_region
}

module "govwifi_deploy" {
  providers = {
    aws = aws.main
  }

  source = "../../govwifi-deploy"

  deployed_app_names     = ["user-signup-api", "logging-api", "admin"]
  built_app_names        = ["frontend", "safe-restarter", "database-backup"]
  frontend_docker_images = ["raddb", "frontend"]
}
