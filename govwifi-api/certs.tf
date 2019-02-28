resource "aws_acm_certificate" "api-elb-global" {
  count             = "${aws_lb.api-alb.count}"
  domain_name       = "${aws_route53_record.elb_global.fqdn}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "api-elb-global" {
  count                   = "${aws_acm_certificate.api-elb-global.count}"
  certificate_arn         = "${aws_acm_certificate.api-elb-global.arn}"
  validation_record_fqdns = ["${aws_route53_record.elb_global_cert_validation.fqdn}"]
}
