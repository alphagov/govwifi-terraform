resource "aws_route53_record" "elb" {
  count   = "${var.backend-elb-count}"
  zone_id = "${var.route53-zone-id}"
  name    = "allowed-sites-api-elb.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"
  alias {
    name                   = "${aws_elb.allowed-sites-api-elb.dns_name}"
    zone_id                = "${aws_elb.allowed-sites-api-elb.zone_id}"
    evaluate_target_health = true
  }
}
