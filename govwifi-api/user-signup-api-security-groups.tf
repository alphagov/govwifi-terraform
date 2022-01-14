resource "aws_security_group" "user_signup_api_lb_in" {
  count  = var.user_signup_api_is_public
  name   = "${var.env_name} User Signup API world inbound"
  vpc_id = var.vpc_id

  ingress {
    description = "Traffic from NAT gateway attached to user-api lambda"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [for ip in var.nat_gateway_elastic_ips : "${ip}/32"]
  }

  ingress {
    description = "Traffic from Notify to confirm SNS signup"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [for ip in var.notify_ips : "${ip}/32"]

  }
}
