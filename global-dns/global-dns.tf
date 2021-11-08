# CNAME for the service status page
resource "aws_route53_record" "statuspage" {
  zone_id = var.route53_zone_id
  name    = "status.${var.env_subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = [var.status_page_domain]
}

