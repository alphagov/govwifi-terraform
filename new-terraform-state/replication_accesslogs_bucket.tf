resource "aws_s3_bucket" "replication_accesslogs_bucket" {
  bucket = "govwifi-${var.env_name}-accesslogs-${data.aws_region.replication.name}"

  tags = {
    Region      = data.aws_region.replication.name
    Environment = title(var.env_name)
    Category    = "Accesslogs"
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

resource "aws_s3_bucket_lifecycle_configuration" "replication_accesslogs_bucket" {
  depends_on = [aws_s3_bucket_versioning.replication_accesslogs_bucket]

  bucket = aws_s3_bucket.replication_accesslogs_bucket.id

  rule {
    id = "accesslogs-lifecycle"

    transition {
      days          = var.accesslogs_glacier_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.accesslogs_expiration_days
    }

    status = "Enabled"
  }
}
