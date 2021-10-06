resource "aws_security_group" "be-perf-out" {
  name        = "be-perf-out"
  description = "Allow outbound RADIUS traffic from the performance testing instance"
  vpc_id      = module.backend.backend-vpc-id

  tags = {
    Name = "${title(var.Env-Name)} Backend performance out"
  }

  # authorisation
  egress {
    from_port   = 1812
    to_port     = 1812
    protocol    = "udp"
    cidr_blocks = [for ip in local.frontend_radius_ips : "${ip}/32"]
  }

  # accounting
  egress {
    from_port   = 1813
    to_port     = 1813
    protocol    = "udp"
    cidr_blocks = [for ip in local.frontend_radius_ips : "${ip}/32"]
  }

  # healthchecks and direct calls to ELB
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # direct calls to ELB
  egress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

