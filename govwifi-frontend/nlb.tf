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

resource "aws_lb_target_group" "frontend-target-group" {
  name     = "frontend-target-group"
  port     = 3000
  protocol = "UDP"
  vpc_id   = "${aws_vpc.wifi-frontend.id}"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    protocol            = "TCP"
  }
}