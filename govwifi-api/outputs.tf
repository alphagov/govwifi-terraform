output "api-base-url" {
  description = "Global base url for API endpoints"
  value       = "https://${aws_route53_record.elb_global.0.fqdn}:${aws_alb_listener.alb_listener.port}"
}

output "api-alb-dns-name" {
  value = "${aws_lb.api-alb.dns_name}"
}
