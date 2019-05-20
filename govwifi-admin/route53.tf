resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "www.${var.Env-Subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["d2j0ojhs7n2cwa.cloudfront.net"]
}

data "aws_route53_zone" "zone" {
  name         = "wifi.service.gov.uk."
  private_zone = false
}
