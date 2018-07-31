resource "aws_route53_record" "admin_platform" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "admin-platform.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"
  alias {
    name                   = "${aws_lb.admin-alb.dns_name}"
    zone_id                = "${aws_lb.admin-alb.zone_id}"
    evaluate_target_health = true
  }
}

data "aws_route53_zone" "zone" {
  name = "wifi.service.gov.uk."
  private_zone = false
}
