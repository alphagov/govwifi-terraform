resource "aws_security_group" "prometheus" {
  name        = "prometheus"
  description = "Security group for the Prometheus server"
  vpc_id      = var.frontend_vpc_id

  tags = {
    Name = "${title(var.env_name)} Prometheus"
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

  egress {
    from_port   = 9812
    to_port     = 9812
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow scraping the FreeRADIUS exporter"
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["${var.grafana_ip}/32"]
  }
}
