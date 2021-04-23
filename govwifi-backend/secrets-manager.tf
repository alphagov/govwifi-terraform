data "aws_secretsmanager_secret_version" "users_db_credentials" {
  secret_id = data.aws_secretsmanager_secret.users_db_credentials.id
}

data "aws_secretsmanager_secret" "users_db_credentials" {
  name = "staging/rds/users-db/credentials"
}