locals {
  slack_workplace_id = jsondecode(data.aws_secretsmanager_secret_version.slack_credentials.secret_string)["workspace-id"]
}

locals {
  slack_channel_id = jsondecode(data.aws_secretsmanager_secret_version.slack_credentials.secret_string)["channel-id"]
}
