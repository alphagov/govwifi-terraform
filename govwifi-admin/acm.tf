resource "aws_acm_certificate" "admin_cert" {
  domain_name       = aws_route53_record.admin.name
  validation_method = "DNS"
}

resource "aws_route53_record" "admin_cert_validation" {
  name    = one(aws_acm_certificate.admin_cert.domain_validation_options).resource_record_name
  type    = one(aws_acm_certificate.admin_cert.domain_validation_options).resource_record_type
  zone_id = var.route53_zone_id
  records = [one(aws_acm_certificate.admin_cert.domain_validation_options).resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.admin_cert.arn
  validation_record_fqdns = [aws_route53_record.admin_cert_validation.fqdn]
}

