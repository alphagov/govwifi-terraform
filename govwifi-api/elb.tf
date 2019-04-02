resource "aws_lb" "api-alb" {
  name     = "api-alb-${var.Env-Name}"
  internal = false
  count    = "${var.backend-elb-count}"
  subnets  = ["${var.subnet-ids}"]

  security_groups = [
    "${aws_security_group.api-alb-in.id}",
    "${aws_security_group.api-alb-out.id}",
  ]

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

resource "aws_security_group" "api-alb-in" {
  name        = "loadbalancer-in"
  description = "Allow Inbound Traffic To The ALB"
  vpc_id      = "${var.vpc-id}"

  tags {
    Name = "${title(var.Env-Name)} ALB Traffic In"
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${var.radius-server-ips}"]
  }
}

resource "aws_security_group" "api-alb-out" {
  name        = "loadbalancer-out"
  description = "Allow Outbound Traffic To The ALB"
  vpc_id      = "${var.vpc-id}"

  tags {
    Name = "${title(var.Env-Name)} ALB Traffic Out"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
