resource "aws_route53_record" "grafana-route53-record" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "grafana.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = "${aws_lb.grafana-alb.dns_name}"
    zone_id                = "${aws_lb.grafana-alb.zone_id}"
    evaluate_target_health = true
  }
}

data "aws_route53_zone" "zone" {
  name         = "wifi.service.gov.uk."
  private_zone = false
}

resource "aws_route53_health_check" "grafana-healthcheck" {
  count             = "${aws_eip_association.grafana_eip_assoc.count}"
  reference_name    = "${var.Env-Name}-${var.aws-region-name}-grafana"
  ip_address        = "${aws_eip_association.grafana_eip_assoc.public_ip}"
  port              = 3000
  type              = "HTTP"
  request_interval  = "30"
  failure_threshold = "3"
  measure_latency   = true
  regions           = ["eu-west-1", "us-east-1", "us-west-1"]

  tags = {
    Name = "${format("${var.Env-Name}-${var.aws-region-name}-%d", count.index + 1)}"
  }
}
