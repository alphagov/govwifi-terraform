resource "aws_security_group" "loadbalancer-in" {
  name        = "loadbalancer-in"
  description = "Allow Inbound Traffic To The ALB"
  vpc_id      = "${var.vpc-id}"

  tags {
    Name = "${title(var.Env-Name)} ALB Traffic In"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${split(",",var.radius-server-ips)}"]
  }
}

resource "aws_security_group" "loadbalancer-out" {
  name        = "loadbalancer-out"
  description = "Allow Outbound Traffic To The ALB"
  vpc_id      = "${var.vpc-id}"

  tags {
    Name = "${title(var.Env-Name)} ALB Traffic Out"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "api-in" {
  name        = "api-in"
  description = "Allow Inbound Traffic To API"
  vpc_id      = "${var.vpc-id}"

  tags {
    Name = "${title(var.Env-Name)} API Traffic In"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = ["${aws_security_group.loadbalancer-out.id}"]
  }
}

resource "aws_security_group" "api-out" {
  name        = "api-out"
  description = "Allow Outbound Traffic From the API"
  vpc_id      = "${var.vpc-id}"

  tags {
    Name = "${title(var.Env-Name)} API Traffic Out"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
