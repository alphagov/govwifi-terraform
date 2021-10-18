# Bucket to store MySQL RDS backups
resource "aws_s3_bucket" "rds_mysql_backup_bucket" {
  count         = var.backup_mysql_rds ? 1 : 0
  bucket        = "govwifi-${var.env_name}-${lower(var.aws_region_name)}-mysql-backup-data"
  force_destroy = true
  acl           = "private"

  tags = {
    Name        = "GovWifi ${title(var.env_name)} RDS MySQL data backup"
    Region      = title(var.aws_region_name)
    Environment = title(var.env_name)
    Category    = "MySQL RDS data backup"
  }

  lifecycle_rule {
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 180
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "alias/${var.env_name}_mysql_rds_backup_s3_key"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket_public_access_block" "rds_mysql_backup_bucket" {
  count  = var.backup_mysql_rds ? 1 : 0
  bucket = aws_s3_bucket.rds_mysql_backup_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

