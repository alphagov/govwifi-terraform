resource "aws_s3_bucket" "replication_accesslogs_bucket" {
  bucket = "govwifi-${var.env_name}-accesslogs-${data.aws_region.replication.name}"

  tags = {
    Region      = data.aws_region.replication.name
    Environment = title(var.env_name)
    Category    = "Accesslogs"
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

resource "aws_s3_bucket_acl" "replication_accesslogs_bucket" {
  bucket = aws_s3_bucket.replication_accesslogs_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_versioning" "replication_accesslogs_bucket" {
  bucket = aws_s3_bucket.replication_accesslogs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
