resource "aws_s3_bucket" "replication_accesslogs_bucket" {
  bucket = "govwifi-${var.env_name}-accesslogs-${data.aws_region.replication.name}"
  acl    = "log-delivery-write"

  tags = {
    Region      = data.aws_region.replication.name
    Environment = title(var.env_name)
    Category    = "Accesslogs"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "accesslogs-lifecycle"
    enabled = true

    transition {
      days          = var.accesslogs_glacier_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.accesslogs_expiration_days
    }
  }
}
