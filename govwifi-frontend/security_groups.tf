# ECS Endpoint addresses

resource "aws_security_group" "fe_ecs_out" {
  name        = "fe-ecs-out"
  description = "Allow the ECS agent to talk to the ECS endpoints"
  vpc_id      = aws_vpc.wifi_frontend.id

  tags = {
    Name = "${title(var.Env-Name)} Frontend ECS out"
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
    # NTP
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic from administrators

resource "aws_security_group" "fe_admin_in" {
  name        = "fe-admin-in"
  description = "Allow inbound traffic from administrators"
  vpc_id      = aws_vpc.wifi_frontend.id

  tags = {
    Name = "${title(var.Env-Name)} Frontend Admin in"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_server_ip}/32"]
  }
}

# Traffic from Prometheus server in London

resource "aws_security_group" "fe_prometheus_in" {
  name        = "fe-prometheus-in"
  description = "Allow inbound traffic from Prometheus server in London"
  vpc_id      = aws_vpc.wifi_frontend.id

  tags = {
    Name = "${title(var.Env-Name)} Frontend Prometheus in"
  }

  ingress {
    from_port = 9812
    to_port   = 9812
    protocol  = "tcp"

    cidr_blocks = distinct([
      var.prometheus-IP-ireland,
      var.prometheus-IP-london,
    ])
  }
}

# API access from the RADIUS servers

resource "aws_security_group" "fe_radius_out" {
  name        = "fe-radius-out"
  description = "Allow outbound API calls from the RADIUS servers"
  vpc_id      = aws_vpc.wifi_frontend.id

  tags = {
    Name = "${title(var.Env-Name)} Frontend RADIUS out"
  }

  # As the frontend servers need to talk across regions, we let this be open.
  # We should look into VPC peering at some point in the future.
  # This also inadvertently gives access to the S3 bucket.
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 9812
    to_port     = 9812
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound data to Prometheus server"
  }
}

# RADIUS traffic to the RADIUS servers

resource "aws_security_group" "fe_radius_in" {
  name        = "fe-radius-in"
  description = "Allow inbound API calls to the RADIUS servers"
  vpc_id      = aws_vpc.wifi_frontend.id

  tags = {
    Name = "${title(var.Env-Name)} Frontend RADIUS in"
  }

  ingress {
    description = "Radius server"
    from_port   = 1812
    to_port     = 1812
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Radius accounting"
    from_port   = 1813
    to_port     = 1813
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow route53 healthcheck"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = distinct(data.aws_ip_ranges.route53_healthcheck.cidr_blocks)
  }

  ingress {
    description = "Allow route53 healthcheck"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = distinct(data.aws_ip_ranges.route53_healthcheck.cidr_blocks)
  }

  ingress {
    description = "Allow FreeRadius Log Exporter in"
    from_port   = 9812
    to_port     = 9812
    protocol    = "tcp"

    cidr_blocks = distinct(var.radius-CIDR-blocks)
  }
}

data "aws_ip_ranges" "route53_healthcheck" {
  services = ["route53_healthchecks"]
  regions  = var.is_production_aws_account ? ["eu-west-1", "us-east-1", "us-west-1"] : ["global"]
}
