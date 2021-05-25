data "aws_secretsmanager_secret_version" "grafana_admin" {
  secret_id = data.aws_secretsmanager_secret.grafana_admin.id
}

data "aws_secretsmanager_secret" "grafana_admin" {
  name = var.use_env_prefix ? "staging/grafana/admin-pass" : "grafana/admin-pass"
}

data "aws_secretsmanager_secret_version" "grafana_server_root_url" {
  secret_id = data.aws_secretsmanager_secret.grafana_server_root_url.id
}

data "aws_secretsmanager_secret" "grafana_server_root_url" {
  name = var.use_env_prefix ? "staging/grafana/server-root-url" : "grafana/server-root-url"
}

data "aws_secretsmanager_secret_version" "google_client_id" {
  secret_id = data.aws_secretsmanager_secret.google_client_id.id
}

data "aws_secretsmanager_secret" "google_client_id" {
  name = var.use_env_prefix ? "staging/grafana/google-client-id" : "grafana/google-client-id"
}

data "aws_secretsmanager_secret_version" "google_client_secret" {
  secret_id = data.aws_secretsmanager_secret.google_client_secret.id
}

data "aws_secretsmanager_secret" "google_client_secret" {
  name = var.use_env_prefix ? "staging/grafana/google-client-secret" : "grafana/google-client-secret"
}
