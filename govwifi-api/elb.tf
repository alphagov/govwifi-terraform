resource "aws_lb" "api-alb" {
  name               = "api-alb-${var.Env-Name}"
  internal           = false
  count              = "${var.backend-elb-count}"
  subnets            = ["${var.subnet-ids}"]
  security_groups    = ["${var.elb-sg-list}"]
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
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "api-elb-global" {
  count           = "${aws_lb.api-alb.count}"
  listener_arn    = "${aws_alb_listener.alb_listener.arn}"
  certificate_arn = "${aws_acm_certificate.api-elb-global.arn}"

  depends_on = [
    "aws_acm_certificate_validation.api-elb-global",
  ]
}
