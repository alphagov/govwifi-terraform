resource "aws_s3_bucket" "frontend-cert-bucket" {
  count  = 1
  bucket = "govwifi-${var.Env-Subdomain}-${lower(var.aws-region-name)}-frontend-cert"
  acl    = "private"

  tags = {
    Name        = "${title(var.Env-Name)} Frontend certs"
    Region      = title(var.aws-region-name)
    Environment = title(var.rack-env)
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
