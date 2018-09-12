resource "aws_s3_bucket" "admin-bucket" {
  count         = 1
  bucket        = "govwifi-${var.rack-env}-admin"
  force_destroy = true
  acl           = "private"

  tags {
    Name        = "${title(var.Env-Name)} Admin data"
    Region      = "${title(var.aws-region-name)}"
    Environment = "${title(var.rack-env)}"
  }

  versioning {
    enabled = true
  }
}
