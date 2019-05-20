locals {
  dns-subdomain = "${var.set-subdomain ? "${var.stage}." : ""}"
}

data "aws_lb" "this" {
  # fetch this dynamically, as we aren't guaranteed to be controlling the loadbalancer
  arn = "${local.loadbalancer-arn}"
}

resource "aws_route53_record" "this" {
  count   = "${local.create-dns-record ? 1 : 0}"
  zone_id = "${var.hosted-zone-id}"
  name    = "admin.${locals.dns-subdomain}"
  type    = "A"

  alias {
    name                   = "${data.aws_lb.this.dns_name}"
    zone_id                = "${data.aws_lb.this.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "certificate-validation" {
  count   = "${aws_acm_certificate.this.count}"
  zone_id = "${var.hosted-zone-id}"
  name    = "${aws_acm_certificate.this.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.this.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.this.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}
