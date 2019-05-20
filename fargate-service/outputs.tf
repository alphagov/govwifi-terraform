output "target-group-arn" {
  value = "${aws_lb_target_group.this.arn}"
}

output "loadbalancer-arn" {
  value = "${data.aws_lb.this.arn}"
}

output "service-security-group-id" {
  value = "${aws_security_group.service.id}"
}

output "loadbalancer-security-group-id" {
  value = "${aws_security_group.lb.id}"
}

output "fqdn" {
  value = "${
    local.create-dns-record
    ? aws_route53_record.this.0.fqdn
    : ""
  }"
}

output "certificate-arn" {
  value = "${
    local.create-dns-record
    ? aws_acm_certificate_validation.this.0.certificate_arn
    : ""
  }"
}
