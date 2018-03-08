# CNAME for all radius servers for this environment
resource "aws_route53_record" "radius" {
  count      = "${var.radius-instance-count}"
  zone_id    = "${var.route53-zone-id}"
  name       = "${format("radius%d.%s.service.gov.uk", var.dns-numbering-base + count.index + 1, var.Env-Subdomain)}"
  type       = "CNAME"
  ttl        = "300"
  records    = ["${element(aws_instance.radius.*.public_dns, count.index)}"]
  depends_on = ["aws_instance.radius", "aws_eip_association.eip_assoc"]
}
