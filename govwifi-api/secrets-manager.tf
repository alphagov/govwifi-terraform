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

data "aws_secretsmanager_secret_version" "volumetrics_elasticsearch_endpoint" {
  secret_id = data.aws_secretsmanager_secret.volumetrics_elasticsearch_endpoint.id
}

data "aws_secretsmanager_secret" "volumetrics_elasticsearch_endpoint" {
  name = "logging-api/volumetrics-elasticsearch-endpoint"
}

data "aws_secretsmanager_secret_version" "notify_api_key" {
  secret_id = data.aws_secretsmanager_secret.notify_api_key.id
}

data "aws_secretsmanager_secret" "notify_api_key" {
  name = "admin-api/notify-api-key"
}

data "aws_secretsmanager_secret_version" "notify_bearer_token" {
  secret_id = data.aws_secretsmanager_secret.notify_bearer_token.id
}

data "aws_secretsmanager_secret" "notify_bearer_token" {
  name = "user-signup-api/notify-bearer-token"
}

data "aws_secretsmanager_secret_version" "admin_db" {
  secret_id = data.aws_secretsmanager_secret.admin_db.id
}

data "aws_secretsmanager_secret" "admin_db" {
  name = "rds/admin-db/credentials"
}

data "aws_secretsmanager_secret_version" "database_s3_encryption" {
  secret_id = data.aws_secretsmanager_secret.database_s3_encryption.id
}

data "aws_secretsmanager_secret" "database_s3_encryption" {
  name = "rds/database-s3-encryption"
}
