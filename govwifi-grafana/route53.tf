resource "aws_route53_record" "grafana-staging" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "grafana-staging.${var.Env-Subdomain}.service.gov.uk"
  type    = "CNAME"
  records = ["d_700724072c65db3cc82b0c4c13b529e6.hkmpvcwbzw.acm-validations.aws."]
}

data "aws_route53_zone" "zone" {
  name         = "wifi.service.gov.uk."
  private_zone = false
}
