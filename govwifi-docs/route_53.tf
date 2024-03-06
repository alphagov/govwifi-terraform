resource "aws_route53_record" "www_wifi" {
  zone_id = var.route53_zone_id
  name    = "www.wifi.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["alphagov.github.io."]
}

resource "aws_route53_record" "wifi_apex" {
  zone_id = var.route53_zone_id
  name    = "wifi.service.gov.uk"
  type    = "A"
  ttl     = "300"
  records = ["185.199.108.153", "185.199.109.153", "185.199.110.153", "185.199.111.153"]
}

resource "aws_route53_record" "tech_docs" {
  zone_id = var.route53_zone_id
  name    = "docs.wifi.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["alphagov.github.io."]
}

resource "aws_route53_record" "dev_docs" {
  zone_id = var.route53_zone_id
  name    = "dev-docs.wifi.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["alphagov.github.io."]
}

