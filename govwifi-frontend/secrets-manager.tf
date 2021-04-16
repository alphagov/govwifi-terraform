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