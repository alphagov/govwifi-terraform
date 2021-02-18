resource "aws_security_group" "grafana-staging-alb-in" {
  name        = "grafana-staging-alb-in"
  description = "Allow Inbound Traffic to the Grafana ALB"
  vpc_id      = "${var.vpc-id}"

  tags = {
    Name = "${title(var.Env-Name)} Grafana ALB Traffic In"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion-ips}"]
  }
}

resource "aws_security_group" "grafana-staging-alb-out" {
  name        = "grafana-staging-alb-out"
  description = "Allow Outbound Traffic from the staging Grafana ALB"
  vpc_id      = "${var.vpc-id}"

  tags = {
    Name = "${title(var.Env-Name)} Grafana ALB Traffic Out"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion-ips}"]
  }
}

resource "aws_security_group" "grafana-staging-ec2-in" {
  name        = "grafana-staging-ec2-in"
  description = "Allow Inbound Traffic To staging Grafana from the ALB"
  vpc_id      = "${var.vpc-id}"

  tags = {
    Name = "${title(var.Env-Name)} Grafana EC2 Traffic In"
  }

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["${aws_security_group.grafana-staging-alb-out.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion-ips}"]
  }
}

resource "aws_security_group" "grafana-staging-ec2-out" {
  name        = "grafana-staging-ec2-out"
  description = "Allow Outbound Traffic From the staging Grafana EC2 container"
  vpc_id      = "${var.vpc-id}"

  tags = {
    Name = "${title(var.Env-Name)} Grafana EC2 Traffic Out"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion-ips}"]
  }
    egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion-ips}"]
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
