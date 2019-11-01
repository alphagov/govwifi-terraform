resource "aws_lb" "frontend-nlb" {
  name               = "frontend-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.wifi-frontend-subnet.*.id}"]

  enable_deletion_protection = false

  ip_address_type = "ipv4"

  tags = {
    Name = "frontend-nlb-${var.Env-Name}"
  }
}