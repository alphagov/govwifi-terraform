locals {
  aws_account_id = jsondecode(data.aws_secretsmanager_secret_version.aws_account_id.secret_string)["account-id"]
}

locals {
  docker_image_path = jsondecode(data.aws_secretsmanager_secret_version.docker_image_path.secret_string)["path"]
}

locals {
  frontend_radius_ips = concat(var.london_radius_ip_addresses, var.dublin_radius_ip_addresses)
}

locals {
  frontend_region_ips = var.london_radius_ip_addresses
}