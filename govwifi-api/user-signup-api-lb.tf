resource "aws_lb" "user-signup-api" {
  count    = var.user-signup-enabled
  name     = "user-signup-api-${var.Env-Name}"
  internal = false
  subnets  = var.subnet-ids

  security_groups = concat(
    [aws_security_group.api-alb-in.id],
    [aws_security_group.api-alb-out.id],
    aws_security_group.user-signup-api-lb-in.*.id
  )

  load_balancer_type = "application"

  tags = {
    Name = "user-signup-api-${var.Env-Name}"
  }
}

resource "aws_lb_listener" "user-signup-api" {
  count             = var.user-signup-enabled
  load_balancer_arn = aws_lb.user-signup-api[0].arn
  port              = "8443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.user-signup-api-global[0].arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = aws_alb_target_group.user-signup-api-tg[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "user-signup-api-regional" {
  count           = var.user-signup-enabled
  listener_arn    = aws_lb_listener.user-signup-api[0].arn
  certificate_arn = aws_acm_certificate.user-signup-api-regional[0].arn

  depends_on = [aws_acm_certificate_validation.user-signup-api-regional]
}

