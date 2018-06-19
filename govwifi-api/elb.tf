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
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}
