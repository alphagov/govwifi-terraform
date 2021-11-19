resource "aws_s3_bucket" "wordlist" {
  bucket = var.is_production_aws_account ? "govwifi-wordlist" : "govwifi-${var.env_name}-wordlist"
  count  = var.wordlist_bucket_count ? 1 : 0
  acl    = "private"

  tags = {
    Name = var.is_production_aws_account ? "wordlist-bucket" : "wordlist-${var.env_name}-bucket"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "wordlist" {
  bucket = aws_s3_bucket.wordlist[0].bucket
  count  = var.wordlist_bucket_count ? 1 : 0
  key    = "wordlist-short"
  source = var.wordlist_file_path
  etag   = filemd5(var.wordlist_file_path)
}
