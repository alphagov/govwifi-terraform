resource "aws_security_group" "api_in" {
  name        = "api-in"
  description = "Allow Inbound Traffic To API"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${title(var.env_name)} API Traffic In"
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.api_alb_out.id]
  }
}

resource "aws_security_group" "api_out" {
  name        = "api-out"
  description = "Allow Outbound Traffic From the API"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${title(var.env_name)} API Traffic Out"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

