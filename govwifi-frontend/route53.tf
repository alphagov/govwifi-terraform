# CNAME for all radius servers for this environment
resource "aws_route53_record" "radius" {
  count   = var.radius_instance_count
  zone_id = var.route53_zone_id
  name = format(
    "radius%d.%s.service.gov.uk",
    var.dns_numbering_base + count.index + 1,
    var.env_subdomain
  )
  type    = "CNAME"
  ttl     = "300"
  records = [element(aws_instance.radius.*.public_dns, count.index)]
  depends_on = [
    aws_instance.radius,
    aws_eip_association.eip_assoc
  ]
}

# TODO This resource can be removed after the switch to the NLBs
resource "aws_route53_health_check" "radius" {
  for_each = {
    for az, subnet
    in aws_subnet.wifi_frontend_subnet :
    index(data.aws_availability_zones.zones.names, az) => subnet.id
  }

  reference_name = format(
    "${var.env_name}-${var.aws_region_name}-frontend-%d",
    each.key + 1
  )
  ip_address        = aws_eip_association.eip_assoc[each.key].public_ip
  port              = 3000
  type              = "HTTP"
  request_interval  = "30"
  failure_threshold = "3"
  measure_latency   = true
  regions           = ["eu-west-1", "us-east-1", "us-west-1"]

  tags = {
    Name = format("${var.env_name}-${var.aws_region_name}-%d", each.key + 1)
  }
}
