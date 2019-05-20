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

data "aws_lb" "this" {
  # fetch this dynamically, as we aren't guaranteed to be controlling the loadbalancer
  arn = "${local.loadbalancer-arn}"
}

resource "aws_lb_listener" "http" {
  count             = "${local.create-loadbalancer ? 1 : 0}"
  load_balancer_arn = "${data.aws_lb.this.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  count             = "${local.create-loadbalancer ? 1 : 0}"
  load_balancer_arn = "${data.aws_lb.this.arn}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${aws_acm_certificate_validation.this.certificate_arn}"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = "${aws_lb_target_group.this.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "this" {
  depends_on           = ["data.aws_lb.this"]
  protocol             = "HTTP"
  vpc_id               = "${var.vpc-id}"
  target_type          = "ip"
  deregistration_delay = 10
  tags                 = "${local.staged-tags}"

  health_check {
    enabled  = "${local.healthchecks-enabled}"
    interval = 10
    matcher  = "200"
    path     = "${var.healthcheck-path}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
