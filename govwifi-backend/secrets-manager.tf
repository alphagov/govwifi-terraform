data "aws_secretsmanager_secret_version" "session_db_credentials" {
  secret_id = data.aws_secretsmanager_secret.session_db_credentials.id
}

data "aws_secretsmanager_secret" "session_db_credentials" {
  name = "rds/session-db/credentials"
}

data "aws_secretsmanager_secret_version" "users_db_credentials" {
  secret_id = data.aws_secretsmanager_secret.users_db_credentials.id
}

data "aws_secretsmanager_secret" "users_db_credentials" {
  name = "rds/users-db/credentials"
}
