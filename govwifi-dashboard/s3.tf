resource "aws_s3_bucket" "metrics_bucket" {
  bucket = "govwifi-${var.env_name}-metrics-bucket"
  acl    = "private"

  tags = {
    Name        = "${title(var.env_name)} Metrics data"
    Environment = title(var.env_name)
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "export_data_bucket" {
  bucket = "govwifi-${var.env_name}-export-data-bucket"
  acl    = "private"

  tags = {
    Name        = "${title(var.env_name)} Exported metrics data"
    Environment = title(var.env_name)
  }

  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket_policy" "export_data_bucket" {
  bucket = aws_s3_bucket.export_data_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "ExportDataBucketToPublic",
    "Statement" : [
      {
        "Sid" : "AllowPublicAccessToExportDataBucket",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.export_data_bucket.arn}/*"
  }] })
}