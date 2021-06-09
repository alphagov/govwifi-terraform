data "aws_secretsmanager_secret_version" "db_session_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_session_credentials.id
}

data "aws_secretsmanager_secret" "db_session_credentials" {
  name = var.use_env_prefix ? "staging/rds/session-db/credentials" : "rds/session-db/credentials"
}