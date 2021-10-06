locals {
  aws_account_id = jsondecode(data.aws_secretsmanager_secret_version.aws_account_id.secret_string)["account-id"]
}

locals {
  docker_image_path = jsondecode(data.aws_secretsmanager_secret_version.docker_image_path.secret_string)["path"]
}

locals {
  route53_zone_id = jsondecode(data.aws_secretsmanager_secret_version.route53_zone_id.secret_string)["route53-zone-id"]
}

locals {
  frontend_radius_ips = concat(var.london-radius-ip-addresses, var.dublin-radius-ip-addresses)
}

locals {
  frontend_region_ips = var.dublin-radius-ip-addresses
}
