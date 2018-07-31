resource "aws_acm_certificate" "admin_platform_cert" {
  domain_name = "${aws_route53_record.admin_platform.name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "admin_platform_cert_validation" {
  name = "${aws_acm_certificate.admin_platform_cert.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.admin_platform_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.admin_platform_cert.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.admin_platform_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.admin_platform_cert_validation.fqdn}"]
}
