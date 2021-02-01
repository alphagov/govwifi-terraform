resource "aws_lb" "grafana-alb" {
  name     = "grafana-alb-${var.Env-Name}"
  internal = false
  subnets  = ["${var.backend-subnet-ids}"]

  security_groups = [
    "${aws_security_group.grafana-alb-in.id}",
    "${aws_security_group.grafana-alb-out.id}",
  ]

  load_balancer_type = "application"

  tags = {
    Name = "grafana-alb-${var.Env-Name}"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.grafana-alb.arn}"
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    target_group_arn = "${aws_alb_target_group.grafana-tg.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "grafana-tg" {
  depends_on           = ["aws_lb.grafana-alb"]
  name                 = "grafana-${var.Env-Name}-fg-tg"
  port                 = "3000"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc-id}"
  target_type          = "ip"
  deregistration_delay = 10

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/healthcheck"
  }

  lifecycle {
    create_before_destroy = true
  }
}
