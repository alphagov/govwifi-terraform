data "aws_secretsmanager_secret_version" "slack_workplace_id" {
  secret_id = data.aws_secretsmanager_secret.slack_workplace_id.id
}

data "aws_secretsmanager_secret" "slack_workplace_id" {
  name = "slack/workplace-id"
}