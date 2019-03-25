resource "aws_acm_certificate" "user-signup-api-global" {
  count             = "${aws_lb.user-signup-api.count}"
  domain_name       = "${aws_route53_record.user-signup-api-global.fqdn}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "user-signup-api-global" {
  count                   = "${aws_acm_certificate.user-signup-api-global.count}"
  certificate_arn         = "${aws_acm_certificate.user-signup-api-global.arn}"
  validation_record_fqdns = ["${aws_route53_record.user-signup-api-global-verification.fqdn}"]
}

resource "aws_acm_certificate" "user-signup-api-regional" {
  count             = "${aws_lb.user-signup-api.count}"
  domain_name       = "${aws_route53_record.user-signup-api-regional.fqdn}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "user-signup-api-regional" {
  count                   = "${aws_acm_certificate.user-signup-api-regional.count}"
  certificate_arn         = "${aws_acm_certificate.user-signup-api-regional.arn}"
  validation_record_fqdns = ["${aws_route53_record.user-signup-api-regional-verification.fqdn}"]
}
