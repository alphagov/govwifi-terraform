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

resource "aws_ses_domain_identity" "main" {
  domain = "${var.env_subdomain}.service.gov.uk"
}

resource "aws_route53_record" "verification_record" {
  zone_id = var.route53_zone_id
  name    = "_amazonses.${var.env_subdomain}.service.gov.uk"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.main.verification_token]
}

