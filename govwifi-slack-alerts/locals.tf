locals {
  slack-workplace-id = jsondecode(data.aws_secretsmanager_secret_version.slack_credentials.secret_string)["workspace-id"]
}

locals {
  slack-channel-id = jsondecode(data.aws_secretsmanager_secret_version.slack_credentials.secret_string)["channel-id"]
}