data "aws_secretsmanager_secret_version" "healthcheck" {
  secret_id = data.aws_secretsmanager_secret.healthcheck.id
}

data "aws_secretsmanager_secret" "healthcheck" {
  name = "staging/radius/healthcheck"
}

data "aws_secretsmanager_secret_version" "shared_key" {
  secret_id = data.aws_secretsmanager_secret.shared_key.id
}

data "aws_secretsmanager_secret" "shared_key" {
  name = "staging/radius/shared-key"
}