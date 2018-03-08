# CNAME for the service status page
resource "aws_route53_record" "statuspage" {
  zone_id = "${var.route53-zone-id}"
  name    = "status.${var.Env-Subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.status-page-domain}"]
}
