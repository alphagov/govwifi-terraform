locals {
  logging_api_namespace = "${var.env_name}-logging-api"
  # authorisation_api_namespace = "${var.env_name}-authorisation-api"
  authentication_api_namespace = "${var.env_name}-authentication-api"
  signup_api_namespace         = "${var.env_name}-user-signup-api"

  safe_restart_docker_image_new     = "${data.aws_secretsmanager_secret_version.tools_account.secret_string}.dkr.ecr.${var.aws_region}.amazonaws.com/govwifi/${var.env}/safe-restarter:latest"
  backup_rds_to_s3_docker_image_new = "${data.aws_secretsmanager_secret_version.tools_account.secret_string}.dkr.ecr.${var.aws_region}.amazonaws.com/govwifi/${var.env}/database-backup:latest"

  logging_docker_image_new = "${data.aws_secretsmanager_secret_version.tools_account.secret_string}.dkr.ecr.${var.aws_region}.amazonaws.com/govwifi/logging-api/${var.env}:latest"

  user_signup_docker_image_new = "${data.aws_secretsmanager_secret_version.tools_account.secret_string}.dkr.ecr.${var.aws_region}.amazonaws.com/govwifi/user-signup-api/${var.env}:latest"

  tools_account_id = data.aws_secretsmanager_secret_version.tools_account.secret_string
}
