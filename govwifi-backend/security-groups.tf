resource "aws_security_group" "be_ecs_out" {
  name        = "be-ecs-out"
  description = "Allow the ECS agent to talk to the ECS endpoints"
  vpc_id      = aws_vpc.wifi_backend.id

  tags = {
    Name = "${title(var.env_name)} Backend ECS out"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [for subnet in aws_subnet.wifi_backend_subnet : subnet.cidr_block]
  }

  egress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = [for subnet in aws_subnet.wifi_backend_subnet : subnet.cidr_block]
  }
}

resource "aws_security_group" "be_db_in" {
  name        = "be-db-in"
  description = "Allow connections to the DB"
  vpc_id      = aws_vpc.wifi_backend.id

  tags = {
    Name = "${title(var.env_name)} Backend DB in"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [for subnet in aws_subnet.wifi_backend_subnet : subnet.cidr_block]
  }
}

resource "aws_security_group" "be_admin_in" {
  name        = "be-admin-in"
  description = "Allow inbound SSH from administrators"
  vpc_id      = aws_vpc.wifi_backend.id

  tags = {
    Name = "${title(var.env_name)} Backend Admin in"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = concat(
      ["${var.bastion_server_ip}/32"],
      [for subnet in aws_subnet.wifi_backend_subnet : subnet.cidr_block]
    )
  }
}

resource "aws_security_group" "be_vpn_in" {
  name        = "be-vpn-in"
  description = "Allow inbound SSH from VPN IPs to the bastion only"
  vpc_id      = aws_vpc.wifi_backend.id

  tags = {
    Name = "${title(var.env_name)} Backend VPN in"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [for ip in var.administrator_ips : "${ip}/32"]
  }
}

resource "aws_security_group" "be_vpn_out" {
  name        = "be-vpn-out"
  description = "Allow outbound SSH from bastion"
  vpc_id      = aws_vpc.wifi_backend.id

  tags = {
    Name = "${title(var.env_name)} Backend VPN out"
  }

  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = distinct(concat(
      [for subnet in aws_subnet.wifi_backend_subnet : subnet.cidr_block],
      [for ip in var.frontend_radius_ips : "${ip}/32"],
      ["${var.prometheus_ip_ireland}/32"],
      ["${var.prometheus_ip_london}/32"],
      ["${var.grafana_ip}/32"],
    ))
  }
}

resource "aws_security_group" "be_radius_api_in" {
  name        = "be-radius-api-in"
  description = "Allow inbound API calls from the RADIUS servers"
  vpc_id      = aws_vpc.wifi_backend.id

  tags = {
    Name = "${title(var.env_name)} Backend RADIUS API in"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [for ip in var.frontend_radius_ips : "${ip}/32"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [for ip in var.frontend_radius_ips : "${ip}/32"]
  }
}

