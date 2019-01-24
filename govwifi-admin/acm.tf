resource "aws_acm_certificate" "admin_cert" {
  domain_name = "${aws_route53_record.admin.name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "admin_cert_validation" {
  name = "${aws_acm_certificate.admin_cert.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.admin_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.admin_cert.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn = "${aws_acm_certificate.admin_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.admin_cert_validation.fqdn}"]
}

resource "aws_acm_certificate" "admin_cert_www" {
  domain_name = "${aws_route53_record.admin_www.name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "admin_cert_www_validation" {
  name = "${aws_acm_certificate.admin_cert_www.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.admin_cert_www.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.admin_cert_www.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "certificate_www" {
  certificate_arn = "${aws_acm_certificate.admin_cert_www.arn}"
  validation_record_fqdns = ["${aws_route53_record.admin_cert_www_validation.fqdn}"]
}
