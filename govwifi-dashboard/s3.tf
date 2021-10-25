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

resource "aws_s3_bucket" "export_data_bucket" {
  bucket = "govwifi-export-data-bucket"
  acl    = "private"

  tags = {
    Name = "Exported metrics data"
  }

  versioning {
    enabled = false
  }
}
