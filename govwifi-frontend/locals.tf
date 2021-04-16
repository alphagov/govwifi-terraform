locals {
  frontend_metrics_namespace = "${var.Env-Name}-frontend"
}

locals {
  healthcheck_identity = jsondecode(data.aws_secretsmanager_secret_version.healthcheck_identity.secret_string)["identity"]
}