resource "aws_lb" "this" {
  count              = "${local.create-loadbalancer ? 1 : 0}"
  name               = "${local.full-name}"
  internal           = false
  load_balancer_type = "application"
  tags               = "${local.staged-tags}"

  subnets = [
    "${local.subnet-ids}",
  ]

  security_groups = [
    "${aws_security_group.lb.id}",
  ]
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.admin-alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${aws_acm_certificate_validation.certificate.certificate_arn}"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = "${aws_alb_target_group.admin-tg.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "admin-tg" {
  depends_on           = ["aws_lb.admin-alb"]
  name                 = "admin-${var.Env-Name}-fg-tg"
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
