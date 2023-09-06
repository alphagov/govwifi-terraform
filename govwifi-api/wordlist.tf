resource "aws_s3_bucket" "wordlist" {
  count = var.create_wordlist_bucket ? 1 : 0

  bucket_prefix = "wordlist-"

  tags = {
    Name = "wordlist"
  }
}

resource "aws_s3_bucket_versioning" "wordlist" {
  count  = var.create_wordlist_bucket ? 1 : 0
  bucket = aws_s3_bucket.wordlist[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "wordlist" {
  count  = var.create_wordlist_bucket ? 1 : 0
  bucket = aws_s3_bucket.wordlist[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "wordlist" {
  bucket = aws_s3_bucket.wordlist[0].bucket
  count  = var.create_wordlist_bucket ? 1 : 0
  key    = "wordlist-short"
  source = var.wordlist_file_path
  etag   = filemd5(var.wordlist_file_path)
}

resource "aws_s3_bucket_policy" "wordlist_bucket_policy" {
  count  = var.create_wordlist_bucket ? 1 : 0
  bucket = aws_s3_bucket.wordlist[0].id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ToolsAccess",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_secretsmanager_secret_version.tools_account.secret_string}:role/govwifi-codebuild-role"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.wordlist[0].id}/*"
        }
    ]
}
POLICY

}
