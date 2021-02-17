resource "aws_route53_record" "grafana-staging" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "grafana.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = "${aws_lb.grafana-staging-alb.dns_name}"
    zone_id                = "${aws_lb.grafana-staging-alb.zone_id}"
    evaluate_target_health = true
  }

}


data "aws_route53_zone" "zone" {
  name         = "wifi.service.gov.uk."
  private_zone = false
}
