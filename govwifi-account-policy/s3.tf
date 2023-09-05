resource "aws_s3_bucket" "iam_user_managment_logs" {
  bucket = "govwifi-iam-user-managment-logs-${var.env}-${lower(var.region_name)}"
}

resource "aws_s3_bucket_public_access_block" "iam_user_managment_logs" {
  bucket = aws_s3_bucket.iam_user_managment_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}