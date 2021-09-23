resource "aws_security_group" "user_signup_api_lb_in" {
  count  = var.user-signup-api-is-public
  name   = "${var.Env-Name} User Signup API world inbound"
  vpc_id = var.vpc-id

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

