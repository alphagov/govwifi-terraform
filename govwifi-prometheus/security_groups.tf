resource "aws_security_group" "grafana-data-in" {
  name        = "grafana-data-in-${var.Env-Name}"
  description = "Allow Inbound Traffic from the Grafana instance to collect data"
  vpc_id      = var.frontend-vpc-id

  tags = {
    Name = "${title(var.Env-Name)} Grafana Data Traffic In"
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = split(",", var.grafana-IP)
  }
}
