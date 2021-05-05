data "aws_kms_key" "rds_kms_key" {
  key_id = "alias/aws/rds"
}

resource "aws_kms_key" "mysql_rds_backup_s3_key" {
  is_enabled              = var.backup_mysql_rds
  description             = "This key is used to encrypt RDS MySQL backup bucket objects"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

