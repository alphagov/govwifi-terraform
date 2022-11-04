locals {
  aws_staging_account_id = jsondecode(data.aws_secretsmanager_secret_version.staging_aws_account_no.secret_string)["account-id"]
}

locals {
  aws_production_account_id = jsondecode(data.aws_secretsmanager_secret_version.production_aws_account_no.secret_string)["account-id"]
}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}
