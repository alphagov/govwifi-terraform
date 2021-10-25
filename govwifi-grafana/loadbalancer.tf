resource "aws_lb" "grafana_alb" {
  name     = "grafana-alb-${var.env_name}"
  internal = false
  subnets  = var.subnet_ids

  security_groups = [
    aws_security_group.grafana_alb_in.id,
    aws_security_group.grafana_alb_out.id
  ]

  load_balancer_type = "application"

  tags = {
    Name = "grafana-alb-${var.env_name}"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.grafana_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.certificate.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = aws_alb_target_group.grafana_tg.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "grafana_tg" {
  depends_on           = [aws_lb.grafana_alb]
  name                 = "grafana-${var.env_name}-fg-tg"
  port                 = "3000"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 10

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/login"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group_attachment" "grafana" {
  target_group_arn = aws_alb_target_group.grafana_tg.arn
  target_id        = aws_instance.grafana_instance.private_ip
  port             = 3000
}
