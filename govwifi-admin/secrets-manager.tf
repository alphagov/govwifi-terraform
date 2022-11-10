data "aws_secretsmanager_secret_version" "notify_api_key" {
  secret_id = data.aws_secretsmanager_secret.notify_api_key.id
}

data "aws_secretsmanager_secret" "notify_api_key" {
  name = "admin-api/notify-api-key"
}

data "aws_secretsmanager_secret_version" "zendesk_api_token" {
  secret_id = data.aws_secretsmanager_secret.zendesk_api_token.id
}

data "aws_secretsmanager_secret" "zendesk_api_token" {
  name = "admin-api/zendesk-api-token"
}

data "aws_secretsmanager_secret_version" "key_base" {
  secret_id = data.aws_secretsmanager_secret.key_base.id
}

data "aws_secretsmanager_secret" "key_base" {
  name = "admin-api/secret-key-base"
}

data "aws_secretsmanager_secret_version" "otp_encryption_key" {
  secret_id = data.aws_secretsmanager_secret.otp_encryption_key.id
}

data "aws_secretsmanager_secret" "otp_encryption_key" {
  name = "admin-api/otp-secret-encryption-key"
}

data "aws_secretsmanager_secret_version" "session_db" {
  secret_id = data.aws_secretsmanager_secret.session_db.id
}

data "aws_secretsmanager_secret" "session_db" {
  name = "rds/session-db/credentials"
}

data "aws_secretsmanager_secret_version" "users_db" {
  secret_id = data.aws_secretsmanager_secret.users_db.id
}

data "aws_secretsmanager_secret" "users_db" {
  name = "rds/users-db/credentials"
}

data "aws_secretsmanager_secret_version" "admin_db" {
  secret_id = data.aws_secretsmanager_secret.admin_db.id
}

data "aws_secretsmanager_secret" "admin_db" {
  name = "rds/admin-db/credentials"
}

data "aws_secretsmanager_secret_version" "google_service_account_backup_credentials" {
  secret_id = data.aws_secretsmanager_secret.google_service_account_backup_credentials.id
}

data "aws_secretsmanager_secret" "google_service_account_backup_credentials" {
  name = "admin/google-service-account-backup-credentials"
}

data "aws_secretsmanager_secret" "sentry_dsn" {
  name = "sentry/admin_dsn"
}

data "aws_secretsmanager_secret_version" "tools_account" {
  secret_id = data.aws_secretsmanager_secret.tools_account.id
}

data "aws_secretsmanager_secret" "tools_account" {
  name = "tools/AccountID"
}
