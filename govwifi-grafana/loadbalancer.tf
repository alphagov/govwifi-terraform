resource "aws_lb" "grafana-alb" {
  name     = "grafana-alb-${var.Env-Name}"
  internal = false
  subnets  = var.subnet-ids

  security_groups = [
    aws_security_group.grafana-alb-in.id,
    aws_security_group.grafana-alb-out.id
  ]

  load_balancer_type = "application"

  tags = {
    Name = "grafana-alb-${var.Env-Name}"
  }
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.grafana-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.certificate.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = aws_alb_target_group.grafana-tg.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "grafana-tg" {
  depends_on           = [aws_lb.grafana-alb]
  name                 = "grafana-${var.Env-Name}-fg-tg"
  port                 = "3000"
  protocol             = "HTTP"
  vpc_id               = var.vpc-id
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

resource "aws_alb_target_group_attachment" "grafana" {
  target_group_arn = aws_alb_target_group.grafana-tg.arn
  target_id        = aws_instance.grafana_instance[0].private_ip
  port             = 3000
}

