resource "aws_s3_bucket" "sync_certs_bucket" {
  bucket = "govwifi-sync-certs-logs-${var.env}-${lower(var.region_name)}"
}

resource "aws_s3_bucket_acl" "sync_certs_bucket_acl" {
  bucket = aws_s3_bucket.sync_certs_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "sync_certs_bucket_block" {
  bucket = aws_s3_bucket.sync_certs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
