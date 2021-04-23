data "aws_secretsmanager_secret_version" "healthcheck_identity" {
  secret_id = data.aws_secretsmanager_secret.healthcheck_identity.id
}

data "aws_secretsmanager_secret" "healthcheck_identity" {
  name = "staging/radius/healthcheck-identity"
}

data "aws_secretsmanager_secret_version" "healthcheck_ssid" {
  secret_id = data.aws_secretsmanager_secret.healthcheck_ssid.id
}

data "aws_secretsmanager_secret" "healthcheck_ssid" {
  name = "staging/radius/healthcheck-ssid"
}

data "aws_secretsmanager_secret_version" "healthcheck_key" {
  secret_id = data.aws_secretsmanager_secret.healthcheck_key.id
}

data "aws_secretsmanager_secret" "healthcheck_key" {
  name = "staging/radius/healthcheck-key"
}

data "aws_secretsmanager_secret_version" "healthcheck_pass" {
  secret_id = data.aws_secretsmanager_secret.healthcheck_pass.id
}

data "aws_secretsmanager_secret" "healthcheck_pass" {
  name = "staging/radius/healthcheck-pass"
}