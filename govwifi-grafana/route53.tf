resource "aws_route53_record" "grafana-route53-record" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "grafana.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = aws_lb.grafana-alb.dns_name
    zone_id                = aws_lb.grafana-alb.zone_id
    evaluate_target_health = true
  }
}

data "aws_route53_zone" "zone" {
  name         = var.is_production_aws_account ? "wifi.service.gov.uk." : "${var.Env-Subdomain}.service.gov.uk."
  private_zone = false
}
