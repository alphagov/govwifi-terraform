resource "aws_lb" "admin_alb" {
  name     = "admin-alb-${var.env_name}"
  internal = false
  subnets  = var.subnet_ids

  security_groups = [
    aws_security_group.admin_alb_in.id,
    aws_security_group.admin_alb_out.id,
  ]

  load_balancer_type = "application"

  tags = {
    Name = "admin-alb-${var.env_name}"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.admin_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.certificate.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = aws_alb_target_group.admin_tg.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.admin_alb.arn
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
