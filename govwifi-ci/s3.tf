resource "aws_s3_bucket" "govwifi_codepipeline_bucket" {
  bucket = "govwifi-codepipeline-artifact-store"

  tags = {
    Name        = "govwifi-codepipeline-artifact-store"
    Environment = "${var.env_name}"
  }
}

resource "aws_s3_bucket_public_access_block" "govwifi_codepipeline_bucket_public_block" {
  bucket = aws_s3_bucket.govwifi_codepipeline_bucket.id

  block_public_acls   = true
  block_public_policy = true
}
