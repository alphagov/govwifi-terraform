resource "aws_acm_certificate" "this" {
  count             = "${local.create-dns-record ? 1 : 0}"
  domain_name       = "${aws_route53_record.this.fqdn}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  count                   = "${aws_acm_certificate.this.count}"
  certificate_arn         = "${aws_acm_certificate.this.arn}"
  validation_record_fqdns = ["${aws_route53_record.certificate-validation.fqdn}"]
}
