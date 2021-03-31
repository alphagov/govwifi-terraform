resource "aws_route53_record" "elb" {
  count   = var.backend-elb-count
  zone_id = var.route53-zone-id
  name    = "api-elb.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = aws_lb.api-alb[0].dns_name
    zone_id                = aws_lb.api-alb[0].zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "elb_global" {
  count          = var.backend-elb-count
  zone_id        = var.route53-zone-id
  name           = "api-elb.${var.Env-Subdomain}.service.gov.uk"
  type           = "A"
  set_identifier = var.aws-region

  alias {
    name                   = aws_route53_record.elb[0].name
    zone_id                = aws_route53_record.elb[0].zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.aws-region
  }
}

resource "aws_route53_record" "elb_global_cert_validation" {
  count   = var.backend-elb-count
  name    = aws_acm_certificate.api-elb-global[0].domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.api-elb-global[0].domain_validation_options[0].resource_record_type
  zone_id = var.route53-zone-id
  records = [aws_acm_certificate.api-elb-global[0].domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "elb_regional_cert_validation" {
  count   = var.backend-elb-count
  name    = aws_acm_certificate.api-elb-regional[0].domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.api-elb-regional[0].domain_validation_options[0].resource_record_type
  zone_id = var.route53-zone-id
  records = [aws_acm_certificate.api-elb-regional[0].domain_validation_options[0].resource_record_value]
  ttl     = 60
}

