output "api-base-url" {
  description = "Global base url for API endpoints"

  # port 8443 is defined by by the ECS
  value = "https://${aws_route53_record.elb_global.0.fqdn}:8443"
}
