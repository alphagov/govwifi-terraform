resource "aws_acm_certificate" "grafana-cert" {
  domain_name       = aws_route53_record.grafana-route53-record.name
  validation_method = "DNS"

  depends_on = [aws_route53_record.grafana-route53-record]
}

resource "aws_route53_record" "grafana-cert-validation" {
  name    = aws_acm_certificate.grafana-cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.grafana-cert.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  records = [aws_acm_certificate.grafana-cert.domain_validation_options[0].resource_record_value]
  ttl     = 60

  depends_on = [aws_acm_certificate.grafana-cert]
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.grafana-cert.arn
  validation_record_fqdns = [aws_route53_record.grafana-cert-validation.fqdn]
}

