locals {
  grafana-admin = jsondecode(data.aws_secretsmanager_secret_version.grafana_credentials.secret_string)["admin-pass"]
}

locals {
  grafana-server-root-url = jsondecode(data.aws_secretsmanager_secret_version.grafana_credentials.secret_string)["url"]
}

locals {
  google-client-id = jsondecode(data.aws_secretsmanager_secret_version.grafana_credentials.secret_string)["id"]
}

locals {
  google-client-secret = jsondecode(data.aws_secretsmanager_secret_version.grafana_credentials.secret_string)["secret"]
}