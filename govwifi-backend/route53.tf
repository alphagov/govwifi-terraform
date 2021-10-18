# Important - zone IDs can be obtained from the management console.
# List hosted zones menu -> right hand side.

# CNAME for the database for this environment
resource "aws_route53_record" "db" {
  count   = var.db_instance_count
  zone_id = var.route53_zone_id
  name    = "db.${lower(var.aws_region_name)}.${var.env_subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.db[0].address]
}

# CNAME for the DB read replica for this environment
resource "aws_route53_record" "rr" {
  count   = var.db_replica_count
  zone_id = var.route53_zone_id
  name    = "rr.${lower(var.aws_region_name)}.${var.env_subdomain}.service.gov.uk"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.read_replica[0].address]
}

resource "aws_route53_record" "users_db" {
  count   = var.db_instance_count
  zone_id = var.route53_zone_id
  name    = var.user_db_hostname
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.users_db[0].address]
}

resource "aws_route53_record" "users_rr" {
  count   = var.user_db_replica_count
  zone_id = var.route53_zone_id
  name    = var.user_rr_hostname
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.users_read_replica[0].address]
}

