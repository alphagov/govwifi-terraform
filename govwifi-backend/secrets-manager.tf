data "aws_secretsmanager_secret_version" "session_db_credentials" {
  secret_id = data.aws_secretsmanager_secret.session_db_credentials.id
}

data "aws_secretsmanager_secret" "session_db_credentials" {
  name = var.use_env_prefix ? "staging/rds/session-db/credentials" : "rds/session-db/credentials"
}