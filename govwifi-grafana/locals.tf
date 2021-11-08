locals {
  grafana_admin = jsondecode(data.aws_secretsmanager_secret_version.grafana_credentials.secret_string)["admin-pass"]
}

locals {
  grafana_server_root_url = jsondecode(data.aws_secretsmanager_secret_version.grafana_credentials.secret_string)["url"]
}

locals {
  google_client_id = jsondecode(data.aws_secretsmanager_secret_version.grafana_credentials.secret_string)["id"]
}

locals {
  google_client_secret = jsondecode(data.aws_secretsmanager_secret_version.grafana_credentials.secret_string)["secret"]
}
