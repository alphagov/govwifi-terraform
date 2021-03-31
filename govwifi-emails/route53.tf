# Important - zone IDs can be obtained from the management console.
# List hosted zones menu -> right hand side.

# MX record for this environment
resource "aws_route53_record" "mx" {
  zone_id = var.route53-zone-id
  name    = "${var.Env-Subdomain}.service.gov.uk"
  type    = "MX"
  ttl     = "300"
  records = [var.mail-exchange-server]
}

