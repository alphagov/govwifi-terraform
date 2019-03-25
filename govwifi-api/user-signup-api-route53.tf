resource "aws_route53_record" "user-signup-api-regional" {
  count   = "${aws_lb.user-signup-api.count}"
  zone_id = "${var.route53-zone-id}"
  name    = "user-signup-api.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = "${aws_lb.user-signup-api.dns_name}"
    zone_id                = "${aws_lb.user-signup-api.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "user-signup-api-global" {
  count          = "${aws_lb.user-signup-api.count}"
  zone_id        = "${var.route53-zone-id}"
  name           = "user-signup-api.${var.Env-Subdomain}.service.gov.uk"
  type           = "A"
  set_identifier = "${var.aws-region}"

  alias {
    name                   = "${aws_route53_record.user-signup-api-regional.name}"
    zone_id                = "${aws_route53_record.user-signup-api-regional.zone_id}"
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = "${var.aws-region}"
  }
}

resource "aws_route53_record" "user-signup-api-regional-verification" {
  count   = "${aws_acm_certificate.user-signup-api-regional.count}"
  name    = "${aws_acm_certificate.user-signup-api-regional.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.user-signup-api-regional.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.route53-zone-id}"
  records = ["${aws_acm_certificate.user-signup-api-regional.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "user-signup-api-global-verification" {
  count   = "${aws_acm_certificate.user-signup-api-global.count}"
  name    = "${aws_acm_certificate.user-signup-api-global.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.user-signup-api-global.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.route53-zone-id}"
  records = ["${aws_acm_certificate.user-signup-api-global.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}
