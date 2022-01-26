# AWS Configuration
# CREATE VPC

resource "aws_vpc" "wifi_backend" {
  cidr_block = var.vpc_cidr_block

  # Hostnames required by the CIS hardened image.
  enable_dns_hostnames = true

  tags = {
    Name = "GovWifi Backend - ${var.env_name}"
  }
}

# CREATE GATEWAY AND DEFAULT ROUTE

resource "aws_internet_gateway" "wifi_backend" {
  vpc_id = aws_vpc.wifi_backend.id

  tags = {
    Name = "Backend Internet GW - ${var.env_name}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.wifi_backend.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wifi_backend.id
}

data "aws_availability_zones" "zones" {}

resource "aws_subnet" "wifi_backend_subnet" {
  for_each = toset(data.aws_availability_zones.zones.names)

  vpc_id                  = aws_vpc.wifi_backend.id
  availability_zone       = each.key
  cidr_block              = "${join(".", slice(split(".", var.vpc_cidr_block), 0, 2))}.${index(data.aws_availability_zones.zones.names, each.key) + 1}.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_name} Backend - AZ: ${each.key} - GovWifi subnet"
  }
}

# log group for db backup
resource "aws_cloudwatch_log_group" "database_backup_log_group" {
  count             = var.backup_mysql_rds ? 1 : 0
  name              = "${var.env_name}-database-backup-log-group"
  retention_in_days = 90
}
