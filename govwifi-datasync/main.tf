#Create s3 bucket for backups
resource "aws_s3_bucket" "govwifi-datasync" {
  bucket = "govwifi-datasync"
  acl    = "private"

  tags = {
    Name        = "Govwifi Datasync"
    Region      = title(var.aws-region)
    Environment = title(var.rack-env)
  }

  versioning {
    enabled = false
  }

}
