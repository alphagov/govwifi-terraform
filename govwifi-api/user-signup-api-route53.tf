resource "aws_route53_record" "user_signup_api_regional" {
  count   = var.user_signup_enabled
  zone_id = var.route53_zone_id
  name    = "user-signup-api.${lower(var.aws_region_name)}.${var.env_subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = aws_lb.user_signup_api[0].dns_name
    zone_id                = aws_lb.user_signup_api[0].zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "user_signup_api_global" {
  count          = var.user_signup_enabled
  zone_id        = var.route53_zone_id
  name           = "user-signup-api.${var.env_subdomain}.service.gov.uk"
  type           = "A"
  set_identifier = var.aws_region

  alias {
    name                   = aws_route53_record.user_signup_api_regional[0].name
    zone_id                = aws_route53_record.user_signup_api_regional[0].zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.aws_region
  }
}

resource "aws_route53_record" "user_signup_api_regional_verification" {
  count   = var.user_signup_enabled
  name    = one(aws_acm_certificate.user_signup_api_regional[0].domain_validation_options).resource_record_name
  type    = one(aws_acm_certificate.user_signup_api_regional[0].domain_validation_options).resource_record_type
  zone_id = var.route53_zone_id
  records = [one(aws_acm_certificate.user_signup_api_regional[0].domain_validation_options).resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "user_signup_api_global_verification" {
  count   = var.user_signup_enabled
  name    = one(aws_acm_certificate.user_signup_api_global[0].domain_validation_options).resource_record_name
  type    = one(aws_acm_certificate.user_signup_api_global[0].domain_validation_options).resource_record_type
  zone_id = var.route53_zone_id
  records = [one(aws_acm_certificate.user_signup_api_global[0].domain_validation_options).resource_record_value]
  ttl     = 60
}

