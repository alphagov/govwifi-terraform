data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

data "aws_secretsmanager_secret" "github_token" {
  name = "github/deployment-user"
}

data "aws_secretsmanager_secret_version" "staging_aws_account_no" {
  secret_id = data.aws_secretsmanager_secret.staging_aws_account_no.id
}

data "aws_secretsmanager_secret" "staging_aws_account_no" {
  name = "staging/AccountID"
}
