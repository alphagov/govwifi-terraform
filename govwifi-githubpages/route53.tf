resource "aws_route53_record" "admin" {
  zone_id = var.route53_zone_id
  name    = "dev-docs.${var.env_subdomain}.service.gov.uk"
  type    = "A"
  ttl     = 300
  records = ["185.199.111.153","185.199.109.153","185.199.108.153","185.199.110.153"]
}