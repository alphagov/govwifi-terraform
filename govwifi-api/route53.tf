resource "aws_route53_record" "elb" {
  count   = "${var.backend-elb-count}"
  zone_id = "${var.route53-zone-id}"
  name    = "api-alb.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"
  alias {
    name                   = "${aws_elb.api-alb.dns_name}"
    zone_id                = "${aws_elb.api-alb.zone_id}"
    evaluate_target_health = true
  }
}
