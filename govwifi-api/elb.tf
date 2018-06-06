resource "aws_lb" "api-alb" {
  name            = "api-alb-${var.Env-Name}"
  internal        = false
  count           = "${var.backend-elb-count}"
  subnets         = ["${var.subnet-ids}"]
  security_groups = ["${var.elb-sg-list}"]
  load_balancer_type = "application"

  tags {
    Name = "api-alb-${var.Env-Name}"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.api-alb.arn}"
  port              = "8443"
  protocol          = "HTTPS"
  certificate_arn   = "${var.elb-ssl-cert-arn}"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "static" {
  depends_on   = ["aws_alb_target_group.alb_target_group"]
  listener_arn = "${aws_alb_listener.alb_listener.arn}"
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group.id}"
  }
  condition {
    field  = "path-pattern"
    values = ["/authorize/*"]
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  depends_on   = ["aws_lb.api-alb"]
  name     = "api-lb-tg-${var.Env-Name}"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = "${var.vpc-id}"

  tags {
    Name = "api-alb-tg-${var.Env-Name}"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/authorize/user/HEALTH"
  }
}
