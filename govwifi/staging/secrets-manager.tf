data "aws_secretsmanager_secret_version" "aws_account_id" {
  secret_id = data.aws_secretsmanager_secret.aws_account_id.id
}

data "aws_secretsmanager_secret" "aws_account_id" {
  name = "staging/aws/account-id"
}