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
