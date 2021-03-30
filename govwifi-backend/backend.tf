# AWS Configuration
# CREATE VPC

resource "aws_vpc" "wifi-backend" {
  cidr_block = var.vpc-cidr-block

  # Hostnames required by the CIS hardened image.
  enable_dns_hostnames = true

  tags = {
    Name = "GovWifi Backend - ${var.Env-Name}"
  }
}

# CREATE GATEWAY AND DEFAULT ROUTE

resource "aws_internet_gateway" "wifi-backend" {
  vpc_id = aws_vpc.wifi-backend.id

  tags = {
    Name = "Backend Internet GW - ${var.Env-Name}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.wifi-backend.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wifi-backend.id
}

# CREATE SUBNET IN EACH AZ

resource "aws_subnet" "wifi-backend-subnet" {
  count                   = var.zone-count
  vpc_id                  = aws_vpc.wifi-backend.id
  availability_zone       = var.zone-names[format("zone%d", count.index)]
  cidr_block              = var.zone-subnets[format("zone%d", count.index)]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.Env-Name} Backend - AZ: ${var.zone-names[format("zone%d", count.index)]} - GovWifi subnet"
  }
}

