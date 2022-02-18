data "aws_secretsmanager_secret_version" "docker_image_path" {
  secret_id = data.aws_secretsmanager_secret.docker_image_path.id
}

data "aws_secretsmanager_secret" "docker_image_path" {
  name = "aws/ecr/docker-image-path/govwifi"
}

# Sentry

data "aws_secretsmanager_secret" "authentication_api_sentry_dsn" {
  name = "sentry/authentication_api_dsn"
}

data "aws_secretsmanager_secret_version" "authentication_api_sentry_dsn" {
  secret_id = data.aws_secretsmanager_secret.authentication_api_sentry_dsn.id
}

data "aws_secretsmanager_secret" "safe_restarter_sentry_dsn" {
  name = "sentry/safe_restarter_dsn"
}

data "aws_secretsmanager_secret_version" "safe_restarter_sentry_dsn" {
  secret_id = data.aws_secretsmanager_secret.safe_restarter_sentry_dsn.id
}

data "aws_secretsmanager_secret" "user_signup_api_sentry_dsn" {
  name = "sentry/user_signup_api_dsn"
}

data "aws_secretsmanager_secret_version" "user_signup_api_sentry_dsn" {
  secret_id = data.aws_secretsmanager_secret.user_signup_api_sentry_dsn.id
}

data "aws_secretsmanager_secret" "logging_api_sentry_dsn" {
  name = "sentry/logging_api_dsn"
}

data "aws_secretsmanager_secret_version" "logging_api_sentry_dsn" {
  secret_id = data.aws_secretsmanager_secret.logging_api_sentry_dsn.id
}

data "aws_secretsmanager_secret" "admin_sentry_dsn" {
  name = "sentry/admin_dsn"
}

data "aws_secretsmanager_secret_version" "admin_sentry_dsn" {
  secret_id = data.aws_secretsmanager_secret.admin_sentry_dsn.id
}

data "aws_secretsmanager_secret" "cyber_account_id" {
  name = "cyber/account-id"
}

data "aws_secretsmanager_secret_version" "cyber_account_id" {
  secret_id = data.aws_secretsmanager_secret.cyber_account_id.id
}
