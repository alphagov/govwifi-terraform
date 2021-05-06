# Bucket to store previously generated stats in Performance Platform JSON format for safekeeping.
resource "aws_s3_bucket" "pp-data-bucket" {
  count         = var.save-pp-data
  bucket        = "${var.Env-Name}-${lower(var.aws-region-name)}-pp-data"
  force_destroy = true
  acl           = "private"

  tags = {
    Name   = "${title(var.Env-Name)} Performance Platform data backup"
    Region = title(var.aws-region-name)
    # Product     = "${var.product-name}"
    Environment = title(var.Env-Name)
    Category    = "Statistics data / backup"
  }

  versioning {
    enabled = true
  }
}

# Bucket to store MySQL RDS backups
resource "aws_s3_bucket" "rds-mysql-backup-bucket" {
  count         = var.backup_mysql_rds ? 0 : 1
  bucket        = "${var.Env-Name}-${lower(var.aws-region-name)}-pp-data"
  force_destroy = true
  acl           = "private"

  tags = {
    Name        = "${title(var.Env-Name)} RDS MySQL data backup"
    Region      = title(var.aws-region-name)
    Environment = title(var.Env-Name)
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
        kms_master_key_id = aws_kms_key.mysql_rds_backup_s3_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }
}
