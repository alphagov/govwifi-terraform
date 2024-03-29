resource "aws_acm_certificate" "api_elb_global" {
  count             = var.backend_elb_count
  domain_name       = aws_route53_record.elb_global[0].fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "api_elb_global" {
  # Production and staging work slightly differently in regards to certificate validation 
  # there is work in the pipeline to sync these up. For now we are adding a conditional.
  count = (var.rack_env == "production") || (var.aws_region_name == "Dublin" && var.rack_env != "production") ? var.backend_elb_count : 0

  certificate_arn         = aws_acm_certificate.api_elb_global[0].arn
  validation_record_fqdns = [aws_route53_record.elb_global_cert_validation[0].fqdn]
}

resource "aws_acm_certificate" "api_elb_regional" {
  count             = var.backend_elb_count
  domain_name       = aws_route53_record.elb[0].fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "api_elb_regional" {
  count                   = var.backend_elb_count
  certificate_arn         = aws_acm_certificate.api_elb_regional[0].arn
  validation_record_fqdns = [aws_route53_record.elb_regional_cert_validation[0].fqdn]
}

