resource "aws_s3_bucket" "wordlist" {
  bucket = "govwifi-wordlist"
  count  = var.wordlist-bucket-count
  acl    = "private"

  tags = {
    Name = "wordlist-bucket"
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
