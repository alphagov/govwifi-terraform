resource "aws_route53_record" "elb" {
  count   = var.backend_elb_count
  zone_id = var.route53_zone_id
  name    = "api-elb.${lower(var.aws_region_name)}.${var.env_subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = aws_lb.api_alb[0].dns_name
    zone_id                = aws_lb.api_alb[0].zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "elb_global" {
  count          = var.backend_elb_count
  zone_id        = var.route53_zone_id
  name           = "api-elb.${var.env_subdomain}.service.gov.uk"
  type           = "A"
  set_identifier = var.aws_region

  alias {
    name                   = aws_route53_record.elb[0].name
    zone_id                = aws_route53_record.elb[0].zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.aws_region
  }
}

resource "aws_route53_record" "elb_global_cert_validation" {
  # Production and staging work slightly differently in regards to certificate validation 
  # there is work in the pipeline to sync these up. For now we are adding a conditional.
  count = (var.rack_env == "production") || (var.aws_region_name == "Dublin" && var.rack_env != "production") ? var.backend_elb_count : 0

  name    = one(aws_acm_certificate.api_elb_global[0].domain_validation_options).resource_record_name
  type    = one(aws_acm_certificate.api_elb_global[0].domain_validation_options).resource_record_type
  zone_id = var.route53_zone_id
  records = [one(aws_acm_certificate.api_elb_global[0].domain_validation_options).resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "elb_regional_cert_validation" {
  count   = var.backend_elb_count
  name    = one(aws_acm_certificate.api_elb_regional[0].domain_validation_options).resource_record_name
  type    = one(aws_acm_certificate.api_elb_regional[0].domain_validation_options).resource_record_type
  zone_id = var.route53_zone_id
  records = [one(aws_acm_certificate.api_elb_regional[0].domain_validation_options).resource_record_value]
  ttl     = 60
}

