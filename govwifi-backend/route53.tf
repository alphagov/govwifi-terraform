# Important - zone IDs can be obtained from the management console.
# List hosted zones menu -> right hand side.

# CNAME for the database for this environment
resource "aws_route53_record" "db" {
  count   = var.db-instance-count
  zone_id = var.route53-zone-id
  name    = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.db[0].address]
}

# CNAME for the DB read replica for this environment
resource "aws_route53_record" "rr" {
  count   = var.db-replica-count
  zone_id = var.route53-zone-id
  name    = "rr.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.read_replica[0].address]
}

resource "aws_route53_record" "users_db" {
  count   = var.db-instance-count
  zone_id = var.route53-zone-id
  name    = var.user-db-hostname
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.users_db[0].address]
}

resource "aws_route53_record" "users_rr" {
  count   = var.user-db-replica-count
  zone_id = var.route53-zone-id
  name    = var.user-rr-hostname
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.users_read_replica[0].address]
}

