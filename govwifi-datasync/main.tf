terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

#Create s3 bucket for backups
resource "aws_s3_bucket" "govwifi_datasync" {
  bucket = "govwifi-datasync"
  acl    = "private"

  tags = {
    Name        = "Govwifi Datasync"
    Region      = title(var.aws_region)
    Environment = title(var.rack_env)
  }
}

resource "aws_s3_bucket_versioning" "govwifi_datasync" {
  bucket = aws_s3_bucket.govwifi_datasync.id

  versioning_configuration {
    status = "Enabled"
  }
}
