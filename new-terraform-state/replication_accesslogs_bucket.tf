resource "aws_s3_bucket" "replication_accesslogs_bucket" {
  bucket = "govwifi-${var.env_name}-accesslogs-${data.aws_region.replication.name}"

  tags = {
    Region   = data.aws_region.replication.name
    Category = "Accesslogs"
  }
}

resource "aws_s3_bucket_public_access_block" "replication_accesslogs_bucket" {
  bucket = aws_s3_bucket.replication_accesslogs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
