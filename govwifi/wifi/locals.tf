locals {
  env_name      = "wifi"
  env_subdomain = "wifi" # Environment specific subdomain to use under the service domain

  product_name = "GovWifi"
}

locals {
  aws_account_id = jsondecode(data.aws_secretsmanager_secret_version.aws_account_id.secret_string)["account-id"]
}

locals {
  docker_image_path = jsondecode(data.aws_secretsmanager_secret_version.docker_image_path.secret_string)["path"]
}

locals {
  pagerduty_https_endpoint = jsondecode(data.aws_secretsmanager_secret_version.pagerduty_config.secret_string)["integration-url"]
}

locals {
  frontend_radius_ips = concat(var.london_radius_ip_addresses, var.dublin_radius_ip_addresses)
}
