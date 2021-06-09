data "aws_secretsmanager_secret_version" "slack_credentials" {
  secret_id = data.aws_secretsmanager_secret.slack_credentials.id
}

data "aws_secretsmanager_secret" "slack_credentials" {
  name = "slack/credentials"
}