locals {
  env_name      = "staging"
  env_subdomain = "staging.wifi" # Environment specific subdomain to use under the service domain

  product_name = "GovWifi"
}

locals {
  authentication_api_sentry_dsn = data.aws_secretsmanager_secret_version.authentication_api_sentry_dsn.secret_string
  safe_restarter_sentry_dsn     = data.aws_secretsmanager_secret_version.safe_restarter_sentry_dsn.secret_string
}

locals {
  aws_account_id = jsondecode(data.aws_secretsmanager_secret_version.aws_account_id.secret_string)["account-id"]
}

locals {
  docker_image_path = jsondecode(data.aws_secretsmanager_secret_version.docker_image_path.secret_string)["path"]
}

locals {
  frontend_radius_ips = concat(var.london_radius_ip_addresses, var.dublin_radius_ip_addresses)
}
