resource "aws_s3_bucket" "metrics-bucket" {
  bucket        = "govwifi-${var.Env-Name}-metrics-bucket"
  force_destroy = true
  acl           = "private"

  tags = {
    Name        = "${title(var.Env-Name)} Metrics data"
    Environment = "${title(var.Env-Name)}"
  }

  versioning {
    enabled = true
  }
}

output "metrics_bucket_arn" {
  description = "the ARN for the metrics bucket"
  value = aws_s3_bucket.metrics-bucket.arn
}
