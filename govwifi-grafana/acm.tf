resource "aws_acm_certificate" "grafana-staging-cert" {
  domain_name       = "${aws_route53_record.grafana-staging.name}"
  count             = "${var.create_staging_route53_record}"
  validation_method = "DNS"

  depends_on = ["aws_route53_record.grafana-staging"]
}

resource "aws_route53_record" "grafana-staging-cert-validation" {
  name    = "${aws_acm_certificate.grafana-staging-cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.grafana-staging-cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.grafana-staging-cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60

  depends_on = ["aws_acm_certificate.grafana-staging-cert"]
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = "${aws_acm_certificate.grafana-staging-cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.grafana-staging-cert-validation.fqdn}"]
}
