data "aws_secretsmanager_secret_version" "grafana_credentials" {
  secret_id = data.aws_secretsmanager_secret.grafana_credentials.id
}

data "aws_secretsmanager_secret" "grafana_credentials" {
  name = "grafana/credentials"
}
