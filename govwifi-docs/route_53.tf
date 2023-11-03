resource "aws_route53_record" "www" {
  zone_id = var.route53_zone_id
  name    = "www.wifi.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["alphagov.github.io."]
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

