resource "aws_acm_certificate" "user-signup-api-global" {
  count             = length(aws_lb.user-signup-api)
  domain_name       = aws_route53_record.user-signup-api-global[0].fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "user-signup-api-global" {
  count                   = length(aws_acm_certificate.user-signup-api-global)
  certificate_arn         = aws_acm_certificate.user-signup-api-global[0].arn
  validation_record_fqdns = [aws_route53_record.user-signup-api-global-verification[0].fqdn]
}

resource "aws_acm_certificate" "user-signup-api-regional" {
  count             = length(aws_lb.user-signup-api)
  domain_name       = aws_route53_record.user-signup-api-regional[0].fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "user-signup-api-regional" {
  count                   = length(aws_acm_certificate.user-signup-api-regional)
  certificate_arn         = aws_acm_certificate.user-signup-api-regional[0].arn
  validation_record_fqdns = [aws_route53_record.user-signup-api-regional-verification[0].fqdn]
}

