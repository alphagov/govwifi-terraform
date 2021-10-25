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
