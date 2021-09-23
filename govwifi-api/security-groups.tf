resource "aws_security_group" "api-in" {
  name        = "api-in"
  description = "Allow Inbound Traffic To API"
  vpc_id      = var.vpc-id

  tags = {
    Name = "${title(var.Env-Name)} API Traffic In"
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.api-alb-out.id]
  }
}

resource "aws_security_group" "api-out" {
  name        = "api-out"
  description = "Allow Outbound Traffic From the API"
  vpc_id      = var.vpc-id

  tags = {
    Name = "${title(var.Env-Name)} API Traffic Out"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

