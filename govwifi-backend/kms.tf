data "aws_kms_key" "rds_kms_key" {
  key_id = "alias/aws/rds"
}