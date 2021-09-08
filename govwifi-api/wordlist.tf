resource "aws_s3_bucket" "wordlist" {
  bucket = var.is_production_aws_account ? "govwifi-wordlist" : "govwifi-${var.Env-Name}-wordlist"
  count  = var.wordlist-bucket-count
  acl    = "private"

  tags = {
    Name = var.is_production_aws_account ? "wordlist-bucket" : "wordlist-${var.Env-Name}-bucket"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "wordlist" {
  bucket = aws_s3_bucket.wordlist[0].bucket
  count  = var.wordlist-bucket-count
  key    = "wordlist-short"
  source = var.wordlist-file-path
  etag   = filemd5(var.wordlist-file-path)
}
