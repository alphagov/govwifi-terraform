data "aws_secretsmanager_secret_version" "notify_api_key" {
  secret_id = data.aws_secretsmanager_secret.notify_api_key.id
}

data "aws_secretsmanager_secret" "notify_api_key" {
  name = var.use_env_prefix ? "staging/admin-api/notify-api-key" : "admin-api/notify-api-key"
}
