resource "aws_route53_record" "admin" {
  zone_id = var.route53_zone_id
  name    = "admin.${var.env_subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = aws_lb.admin_alb.dns_name
    zone_id                = aws_lb.admin_alb.zone_id
    evaluate_target_health = true
  }
}
