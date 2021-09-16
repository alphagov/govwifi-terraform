resource "aws_acm_certificate" "user_signup_api_global" {
  count             = var.user-signup-enabled
  domain_name       = aws_route53_record.user_signup_api_global[0].fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "user_signup_api_global" {
  count                   = var.user-signup-enabled
  certificate_arn         = aws_acm_certificate.user_signup_api_global[0].arn
  validation_record_fqdns = [aws_route53_record.user_signup_api_global_verification[0].fqdn]
}

resource "aws_acm_certificate" "user_signup_api_regional" {
  count             = var.user-signup-enabled
  domain_name       = aws_route53_record.user_signup_api_regional[0].fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "user_signup_api_regional" {
  count                   = var.user-signup-enabled
  certificate_arn         = aws_acm_certificate.user_signup_api_regional[0].arn
  validation_record_fqdns = [aws_route53_record.user_signup_api_regional_verification[0].fqdn]
}

