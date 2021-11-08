resource "aws_route53_record" "admin" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "admin.${var.env_subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = aws_lb.admin_alb.dns_name
    zone_id                = aws_lb.admin_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "www.${var.env_subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["d2j0ojhs7n2cwa.cloudfront.net"]
}

data "aws_route53_zone" "zone" {
  name         = var.is_production_aws_account ? "wifi.service.gov.uk." : "${var.env_subdomain}.service.gov.uk."
  private_zone = false
}
