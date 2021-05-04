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

data "aws_secretsmanager_secret_version" "session_db" {
  secret_id = data.aws_secretsmanager_secret.session_db.id
}

data "aws_secretsmanager_secret" "session_db" {
  name = var.use_env_prefix ? "staging/rds/session-db/credentials" : "rds/session-db/credentials"
}

data "aws_secretsmanager_secret_version" "users_db" {
  secret_id = data.aws_secretsmanager_secret.users_db.id
}

data "aws_secretsmanager_secret" "users_db" {
  name = var.use_env_prefix ? "staging/rds/users-db/credentials" : "rds/users-db/credentials"
}

data "aws_secretsmanager_secret_version" "admin_db" {
  secret_id = data.aws_secretsmanager_secret.admin_db.id
}

data "aws_secretsmanager_secret" "admin_db" {
  name = var.use_env_prefix ? "staging/rds/admin-db/credentials" : "rds/admin-db/credentials"
}