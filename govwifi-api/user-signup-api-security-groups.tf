resource "aws_security_group" "user_signup_api_lb_in" {
  count  = var.user_signup_api_is_public
  name   = "${var.env_name} User Signup API world inbound"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

