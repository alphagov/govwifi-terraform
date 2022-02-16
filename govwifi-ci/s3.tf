resource "aws_s3_bucket" "govwifi_codepipeline_bucket" {
  bucket = "govwifi-codepipeline-artifact-store"

  tags = {
    Name        = "govwifi-codepipeline-artifact-store"
    Environment = "${var.env_name}"
  }
}

resource "aws_s3_bucket_acl" "govwifi_codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.govwifi_codepipeline_bucket.id
  acl    = "private"
}
