resource "aws_route53_record" "grafana_route53_record" {
  zone_id = var.route53_zone_id
  name    = "grafana.${var.env_subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = aws_lb.grafana_alb.dns_name
    zone_id                = aws_lb.grafana_alb.zone_id
    evaluate_target_health = true
  }
}
