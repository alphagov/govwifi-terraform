# TODO This should probably be managed by Terraform at some point
data "aws_route53_zone" "main" {
  name = "${var.env_subdomain}.service.gov.uk."
}