resource "aws_acm_certificate" "api-elb-global" {
  count             = length(aws_lb.api-alb)
  domain_name       = aws_route53_record.elb_global[0].fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "api-elb-global" {
  count                   = length(aws_acm_certificate.api-elb-global)
  certificate_arn         = aws_acm_certificate.api-elb-global[0].arn
  validation_record_fqdns = [aws_route53_record.elb_global_cert_validation[0].fqdn]
}

resource "aws_acm_certificate" "api-elb-regional" {
  count             = length(aws_lb.api-alb)
  domain_name       = aws_route53_record.elb[0].fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "api-elb-regional" {
  count                   = length(aws_acm_certificate.api-elb-regional)
  certificate_arn         = aws_acm_certificate.api-elb-regional[0].arn
  validation_record_fqdns = [aws_route53_record.elb_regional_cert_validation[0].fqdn]
}

