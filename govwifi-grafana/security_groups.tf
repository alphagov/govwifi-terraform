resource "aws_security_group" "grafana-alb-in" {
  name        = "grafana-alb-in-${var.Env-Name}"
  description = "Allow Inbound Traffic to the Grafana ALB"
  vpc_id      = var.vpc-id

  tags = {
    Name = "${title(var.Env-Name)} Grafana ALB Traffic In"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = split(",", var.administrator-IPs)
  }
}

resource "aws_security_group" "grafana-alb-out" {
  name        = "grafana-alb-out-${var.Env-Name}"
  description = "Allow Outbound Traffic from the Grafana ALB"
  vpc_id      = var.vpc-id

  tags = {
    Name = "${title(var.Env-Name)} Grafana ALB Traffic Out"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.bastion-ips
  }
}

resource "aws_security_group" "grafana-ec2-in" {
  name        = "grafana-ec2-in-${var.Env-Name}"
  description = "Allow Inbound Traffic To Grafana from the ALB"
  vpc_id      = var.vpc-id

  tags = {
    Name = "${title(var.Env-Name)} Grafana EC2 Traffic In"
  }

  ingress {
    description     = ""
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.grafana-alb-out.id]
  }

  ingress {
    description = ""
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion-ips
  }
}

resource "aws_security_group" "grafana-ec2-out" {
  name        = "grafana-ec2-out-${var.Env-Name}"
  description = "Allow Outbound Traffic From the Grafana EC2 container"
  vpc_id      = var.vpc-id

  tags = {
    Name = "${title(var.Env-Name)} Grafana EC2 Traffic Out"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.bastion-ips
  }

  egress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.prometheus-IPs
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
}
