locals {
  grafana-admin = jsondecode(data.aws_secretsmanager_secret_version.grafana_admin.secret_string)["admin-pass"]
}

locals {
  grafana-server-root-url = jsondecode(data.aws_secretsmanager_secret_version.grafana_server_root_url.secret_string)["url"]
}

locals {
  google-client-id = jsondecode(data.aws_secretsmanager_secret_version.google_client_id.secret_string)["id"]
}

locals {
  google-client-secret = jsondecode(data.aws_secretsmanager_secret_version.google_client_secret.secret_string)["secret"]
}