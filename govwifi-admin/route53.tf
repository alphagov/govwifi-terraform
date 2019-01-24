resource "aws_route53_record" "admin" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "admin.${var.Env-Subdomain}.service.gov.uk"
  type    = "A"
  alias {
    name                   = "${aws_lb.admin-alb.dns_name}"
    zone_id                = "${aws_lb.admin-alb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "admin_www" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "www.admin.${var.Env-Subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["admin.${var.Env-Subdomain}.service.gov.uk"]
}

resource "aws_route53_record" "docs_www" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "www.docs.${var.Env-Subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["docs.${var.Env-Subdomain}.service.gov.uk"]
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "www.${var.Env-Subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.Env-Subdomain}.service.gov.uk"]
}

data "aws_route53_zone" "zone" {
  name = "wifi.service.gov.uk."
  private_zone = false
}
