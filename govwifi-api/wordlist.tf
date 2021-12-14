resource "aws_s3_bucket" "wordlist" {
  count = var.create_wordlist_bucket ? 1 : 0

  bucket_prefix = "wordlist-"
  acl           = "private"

  tags = {
    Name = "wordlist"
    Env  = title(var.env_name)
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "wordlist" {
  bucket = aws_s3_bucket.wordlist[0].bucket
  count  = var.create_wordlist_bucket ? 1 : 0
  key    = "wordlist-short"
  source = var.wordlist_file_path
  etag   = filemd5(var.wordlist_file_path)
}
