resource "aws_route53_record" "elb" {
  count   = "${var.backend-elb-count}"
  zone_id = "${var.route53-zone-id}"
  name    = "api-elb.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = "${aws_lb.api-alb.dns_name}"
    zone_id                = "${aws_lb.api-alb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "elb_global" {
  count          = "${var.backend-elb-count}"
  zone_id        = "${var.route53-zone-id}"
  name           = "api-elb.${var.Env-Subdomain}.service.gov.uk"
  type           = "A"
  set_identifier = "${var.aws-region}"

  alias {
    name                   = "${aws_route53_record.elb.name}"
    zone_id                = "${aws_route53_record.elb.zone_id}"
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = "${var.aws-region}"
  }
}
