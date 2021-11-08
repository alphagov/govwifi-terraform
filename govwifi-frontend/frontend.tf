# AWS Configuration
# CREATE VPC

resource "aws_vpc" "wifi_frontend" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "GovWifi Frontend - ${var.env_name}"
  }
}

# CREATE GATEWAY AND DEFAULT ROUTE

resource "aws_internet_gateway" "wifi_frontend" {
  vpc_id = aws_vpc.wifi_frontend.id

  tags = {
    Name = "Frontend Internet GW - ${var.env_name}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.wifi_frontend.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wifi_frontend.id
}

# CREATE SUBNET IN EACH AZ

resource "aws_subnet" "wifi_frontend_subnet" {
  count                   = var.zone_count
  vpc_id                  = aws_vpc.wifi_frontend.id
  availability_zone       = var.zone_names[format("zone%d", count.index)]
  cidr_block              = var.zone_subnets[format("zone%d", count.index)]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_name} Frontend - AZ: ${var.zone_names[format("zone%d", count.index)]} - GovWifi subnet"
  }
}

