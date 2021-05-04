data "aws_secretsmanager_secret_version" "notify_api_key" {
  secret_id = data.aws_secretsmanager_secret.notify_api_key.id
}

data "aws_secretsmanager_secret" "notify_api_key" {
  name = var.use_env_prefix ? "staging/admin-api/notify-api-key" : "admin-api/notify-api-key"
}

data "aws_secretsmanager_secret_version" "zendesk_api_token" {
  secret_id = data.aws_secretsmanager_secret.zendesk_api_token.id
}

data "aws_secretsmanager_secret" "zendesk_api_token" {
  name = var.use_env_prefix ? "staging/admin-api/zendesk-api-token" : "admin-api/zendesk-api-token"
}

data "aws_secretsmanager_secret_version" "key_base" {
  secret_id = data.aws_secretsmanager_secret.key_base.id
}

data "aws_secretsmanager_secret" "key_base" {
  name = var.use_env_prefix ? "staging/admin-api/secret-key-base" : "admin-api/secret-key-base"
}

data "aws_secretsmanager_secret_version" "otp_encryption_key" {
  secret_id = data.aws_secretsmanager_secret.otp_encryption_key.id
}

data "aws_secretsmanager_secret" "otp_encryption_key" {
  name = var.use_env_prefix ? "staging/admin-api/otp-secret-encryption-key" : "admin-api/otp-secret-encryption-key"
}