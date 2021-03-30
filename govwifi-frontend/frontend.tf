# AWS Configuration
# CREATE VPC

resource "aws_vpc" "wifi-frontend" {
  cidr_block           = var.vpc-cidr-block
  enable_dns_hostnames = true

  tags = {
    Name = "GovWifi Frontend - ${var.Env-Name}"
  }
}

# CREATE GATEWAY AND DEFAULT ROUTE

resource "aws_internet_gateway" "wifi-frontend" {
  vpc_id = aws_vpc.wifi-frontend.id

  tags = {
    Name = "Frontend Internet GW - ${var.Env-Name}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.wifi-frontend.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wifi-frontend.id
}

# CREATE SUBNET IN EACH AZ

resource "aws_subnet" "wifi-frontend-subnet" {
  count                   = var.zone-count
  vpc_id                  = aws_vpc.wifi-frontend.id
  availability_zone       = var.zone-names[format("zone%d", count.index)]
  cidr_block              = var.zone-subnets[format("zone%d", count.index)]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.Env-Name} Frontend - AZ: ${var.zone-names[format("zone%d", count.index)]} - GovWifi subnet"
  }
}

