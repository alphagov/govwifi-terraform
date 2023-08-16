# Bucket to store MySQL RDS backups
# Please notify the CDIO IT team if the bucket name is changed.
# The bucket is used in the GovWifi's offsite backup script.
resource "aws_s3_bucket" "rds_mysql_backup_bucket" {
  count         = var.backup_mysql_rds ? 1 : 0
  bucket        = "govwifi-${var.env_name}-${lower(var.aws_region_name)}-mysql-backup-data"
  force_destroy = true

  tags = {
    Name     = "GovWifi ${title(var.env_name)} RDS MySQL data backup"
    Region   = title(var.aws_region_name)
    Category = "MySQL RDS data backup"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "rds_mysql_backup_bucket" {
  count  = var.backup_mysql_rds ? 1 : 0
  bucket = aws_s3_bucket.rds_mysql_backup_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "alias/mysql_rds_backup_s3_key"
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "rds_mysql_backup_bucket" {
  count  = var.backup_mysql_rds ? 1 : 0
  bucket = aws_s3_bucket.rds_mysql_backup_bucket[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "rds_mysql_backup_bucket" {
  count      = var.backup_mysql_rds ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.rds_mysql_backup_bucket]

  bucket = aws_s3_bucket.rds_mysql_backup_bucket[0].id

  rule {
    id = "expiration"

    transition {
      days = 30
      storage_class   = "STANDARD_IA"
    }

    transition {
      days = 60
      storage_class   = "GLACIER"
    }

    expiration {
      days = 180
    }

    status = "Enabled"
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
