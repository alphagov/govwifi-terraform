data "aws_eip" "radius_ips" {
  count     = "${length(var.elastic-ip-list)}"
  public_ip = "${replace(element(var.elastic-ip-list, count.index), "/32", "")}"
}

resource "aws_lb" "frontend-nlb" {
  name               = "frontend-nlb-${var.Env-Name}"
  internal           = false
  load_balancer_type = "network"

  enable_deletion_protection = false

  tags = {
    Name = "frontend-nlb-${var.Env-Name}"
  }

  subnet_mapping {
    subnet_id     = "${aws_subnet.wifi-frontend-subnet.0.id}"
    allocation_id = "${data.aws_eip.radius_ips.0.id}"
  }

  subnet_mapping {
    subnet_id     = "${aws_subnet.wifi-frontend-subnet.1.id}"
    allocation_id = "${data.aws_eip.radius_ips.1.id}"
  }

  subnet_mapping {
    subnet_id     = "${aws_subnet.wifi-frontend-subnet.2.id}"
    allocation_id = "${data.aws_eip.radius_ips.2.id}"
  }
}

resource "aws_lb_target_group" "frontend-target-group" {
  name     = "front-tg-staging"
  port     = 3000
  protocol = "TCP_UDP"
  vpc_id   = "${aws_vpc.wifi-frontend.id}"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
  }

  tags = {
    Name = "frontend-tg-${var.Env-Name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "frontend-healthcheck" {
  count            = "${aws_instance.radius.count}"
  target_group_arn = "${aws_lb_target_group.frontend-target-group.arn}"
  target_id        = "${element(aws_instance.radius.*.id, count.index)}"
  port             = 3000
}

resource "aws_lb_listener" "healthcheck" {
  load_balancer_arn = "${aws_lb.frontend-nlb.arn}"
  port              = 3000
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.frontend-target-group.arn}"
  }
}

resource "aws_lb_listener" "radius-server" {
  load_balancer_arn = "${aws_lb.frontend-nlb.arn}"
  port              = 1812
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.frontend-target-group.arn}"
  }
}

resource "aws_lb_listener" "radius-accounting" {
  load_balancer_arn = "${aws_lb.frontend-nlb.arn}"
  port              = 1813
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.frontend-target-group.arn}"
  }
}
