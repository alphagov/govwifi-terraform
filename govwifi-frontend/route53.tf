# CNAME for all radius servers for this environment
resource "aws_route53_record" "radius" {
  count   = var.radius_instance_count
  zone_id = var.route53_zone_id
  name = format(
    "radius%d.%s.service.gov.uk",
    var.dns_numbering_base + count.index + 1,
    var.env_subdomain
  )
  type    = "A"
  ttl     = "300"
  records = [element(aws_eip.radius_eips.*.public_ip, count.index)]
}
