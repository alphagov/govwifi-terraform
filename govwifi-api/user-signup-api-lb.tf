resource "aws_lb" "user-signup-api" {
  count              = "${var.user-signup-enabled}"
  name               = "user-signup-api-${var.Env-Name}"
  internal           = false
  subnets            = ["${var.subnet-ids}"]
  security_groups    = ["${var.elb-sg-list}"]
  load_balancer_type = "application"

  tags {
    Name = "user-signup-api-${var.Env-Name}"
  }
}

resource "aws_lb_listener" "user-signup-api" {
  count             = "${aws_lb.user-signup-api.count}"
  load_balancer_arn = "${aws_lb.user-signup-api.arn}"
  port              = "8443"
  protocol          = "HTTPS"
  certificate_arn   = "${aws_acm_certificate.user-signup-api-global.arn}"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = "${aws_alb_target_group.user-signup-api-tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "user-signup-api-regional" {
  count           = "${aws_lb.user-signup-api.count}"
  listener_arn    = "${aws_lb_listener.user-signup-api.arn}"
  certificate_arn = "${aws_acm_certificate.user-signup-api-regional.arn}"

  depends_on = [
    "aws_acm_certificate_validation.user-signup-api-regional",
  ]
}
