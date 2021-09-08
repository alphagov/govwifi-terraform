resource "aws_route53_record" "admin" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "admin.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"

  alias {
    name                   = aws_lb.admin-alb.dns_name
    zone_id                = aws_lb.admin-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "www.${var.Env-Subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["d2j0ojhs7n2cwa.cloudfront.net"]
}

data "aws_route53_zone" "zone" {
  name         = var.is_production_aws_account ? "wifi.service.gov.uk." :"${var.Env-Subdomain}.service.gov.uk."
  private_zone = false
}
