locals {
  slack-workplace-id = jsondecode(data.aws_secretsmanager_secret_version.slack_workplace_id.secret_string)["id"]
}