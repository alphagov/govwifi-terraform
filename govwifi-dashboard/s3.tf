resource "aws_s3_bucket" "metrics_bucket" {
  bucket = "govwifi-${var.Env-Name}-metrics-bucket"
  acl    = "private"

  tags = {
    Name        = "${title(var.Env-Name)} Metrics data"
    Environment = title(var.Env-Name)
  }

  versioning {
    enabled = true
  }
}

