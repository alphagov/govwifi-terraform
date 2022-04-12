locals {
  env_name      = "staging"
  env_subdomain = "staging.wifi" # Environment specific subdomain to use under the service domain

  product_name = "GovWifi"

  backup_mysql_rds = true
}

locals {
  authentication_api_sentry_dsn = data.aws_secretsmanager_secret_version.authentication_api_sentry_dsn.secret_string
  user_signup_api_sentry_dsn    = data.aws_secretsmanager_secret_version.user_signup_api_sentry_dsn.secret_string
  logging_api_sentry_dsn        = data.aws_secretsmanager_secret_version.logging_api_sentry_dsn.secret_string
  admin_sentry_dsn              = data.aws_secretsmanager_secret_version.admin_sentry_dsn.secret_string
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

locals {
  docker_image_path = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.docker_image_path.secret_string)["path"])
}

locals {
  frontend_radius_ips = concat(var.london_radius_ip_addresses, var.dublin_radius_ip_addresses)
}
