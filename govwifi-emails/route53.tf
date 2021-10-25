# Important - zone IDs can be obtained from the management console.
# List hosted zones menu -> right hand side.

# MX record for this environment
resource "aws_route53_record" "mx" {
  zone_id = var.route53_zone_id
  name    = "${var.env_subdomain}.service.gov.uk"
  type    = "MX"
  ttl     = "300"
  records = [var.mail_exchange_server]
}

