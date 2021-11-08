resource "aws_security_group" "grafana_data_in" {
  name        = "grafana-data-in-${var.env_name}"
  description = "Allow Inbound Traffic from the Grafana instance to collect data"
  vpc_id      = var.frontend_vpc_id

  tags = {
    Name = "${title(var.env_name)} Grafana Data Traffic In"
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["${var.grafana_ip}/32"]
  }
}
