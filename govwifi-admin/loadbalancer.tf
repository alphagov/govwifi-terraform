resource "aws_lb" "admin_alb" {
  name     = "admin-alb-${var.env_name}"
  internal = false
  subnets  = var.subnet_ids

  security_groups = [
    aws_security_group.admin_alb_in.id,
    aws_security_group.admin_alb_out.id,
  ]

  access_logs {
    bucket  = aws_s3_bucket.access_logs.bucket
    enabled = true
  }

  load_balancer_type = "application"

  tags = {
    Name = "admin-alb-${var.env_name}"
  }
}

resource "aws_s3_bucket" "access_logs" {
  bucket_prefix = "govwifi-admin-access-logs-"
  acl           = "private"

  tags = {
    Name        = "${title(var.env_name)} admin access logs"
    Region      = title(var.aws_region_name)
    Environment = title(var.rails_env)
  }
}

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket_policy" "admin_logs" {
  bucket = aws_s3_bucket.access_logs.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.main.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": ["${aws_s3_bucket.access_logs.arn}/AWSLogs/*"]
    }
  ]
}
POLICY
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
