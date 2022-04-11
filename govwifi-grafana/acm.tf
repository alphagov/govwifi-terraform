resource "aws_acm_certificate" "grafana_cert" {
  domain_name       = aws_route53_record.grafana_route53_record.name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "grafana_cert_validation" {
  name    = one(aws_acm_certificate.grafana_cert.domain_validation_options).resource_record_name
  type    = one(aws_acm_certificate.grafana_cert.domain_validation_options).resource_record_type
  zone_id = var.route53_zone_id

  records = [one(aws_acm_certificate.grafana_cert.domain_validation_options).resource_record_value]
  ttl     = 60

  depends_on = [aws_acm_certificate.grafana_cert]
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.grafana_cert.arn
  validation_record_fqdns = [aws_route53_record.grafana_cert_validation.fqdn]
}

