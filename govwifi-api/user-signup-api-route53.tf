resource "aws_route53_record" "user-signup-api-regional" {
  count   = length(aws_lb.user-signup-api)
  zone_id = var.route53-zone-id
  name    = "user-signup-api.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = aws_lb.user-signup-api[0].dns_name
    zone_id                = aws_lb.user-signup-api[0].zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "user-signup-api-global" {
  count          = length(aws_lb.user-signup-api)
  zone_id        = var.route53-zone-id
  name           = "user-signup-api.${var.Env-Subdomain}.service.gov.uk"
  type           = "A"
  set_identifier = var.aws-region

  alias {
    name                   = aws_route53_record.user-signup-api-regional[0].name
    zone_id                = aws_route53_record.user-signup-api-regional[0].zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.aws-region
  }
}

resource "aws_route53_record" "user-signup-api-regional-verification" {
  count   = length(aws_acm_certificate.user-signup-api-regional)
  name    = aws_acm_certificate.user-signup-api-regional[0].domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.user-signup-api-regional[0].domain_validation_options[0].resource_record_type
  zone_id = var.route53-zone-id
  records = [aws_acm_certificate.user-signup-api-regional[0].domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "user-signup-api-global-verification" {
  count   = length(aws_acm_certificate.user-signup-api-global)
  name    = aws_acm_certificate.user-signup-api-global[0].domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.user-signup-api-global[0].domain_validation_options[0].resource_record_type
  zone_id = var.route53-zone-id
  records = [aws_acm_certificate.user-signup-api-global[0].domain_validation_options[0].resource_record_value]
  ttl     = 60
}

