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

resource "aws_ssm_parameter" "frontend_cert_bucket" {
  name        = "/govwifi-terraform/frontend-certs-bucket"
  description = "Name of the frontend-certs bucket for ${var.aws_region_name}"
  type        = "String"
  value       = aws_s3_bucket.frontend_cert_bucket.bucket
}

resource "aws_iam_policy" "govwifi_frontend_cert_bucket_access" {
  name = "govwifi-sync-cert-access-${lower(var.aws_region_name)}"

  path        = "/"
  description = "Allows govwifi-deploy-pipeline to write to the cert bucket."

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "govwifiSyncCertAccess",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": [
                "${aws_s3_bucket.frontend_cert_bucket.arn}/*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "govwifi_sync_cert_access_policy_attachment" {
  user       = "govwifi-deploy-pipeline" # TODO This should reference the resource
  policy_arn = aws_iam_policy.govwifi_frontend_cert_bucket_access.arn
}
