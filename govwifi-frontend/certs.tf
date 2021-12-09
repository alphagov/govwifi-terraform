resource "aws_s3_bucket" "frontend_cert_bucket" {
  bucket = var.is_production_aws_account ? "govwifi-${var.rack_env}-${lower(var.aws_region_name)}-frontend-cert" : "govwifi-${var.env_subdomain}-${lower(var.aws_region_name)}-frontend-cert"
  acl    = "private"

  tags = {
    Name        = "${title(var.env_name)} Frontend certs"
    Region      = title(var.aws_region_name)
    Environment = title(var.rack_env)
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}
