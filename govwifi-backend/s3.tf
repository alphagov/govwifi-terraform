# Bucket to store previously generated stats in Performance Platform JSON format for safekeeping.
resource "aws_s3_bucket" "pp-data-bucket" {
  count         = "${var.save-pp-data}"
  bucket        = "${var.Env-Name}-${lower(var.aws-region-name)}-pp-data"
  force_destroy = true
  acl           = "private"

  tags = {
    Name   = "${title(var.Env-Name)} Performance Platform data backup"
    Region = "${title(var.aws-region-name)}"

    # Product     = "${var.product-name}"
    Environment = "${title(var.Env-Name)}"
    Category    = "Statistics data / backup"
  }

  versioning {
    enabled = true
  }
}

# bucket to write and read internal metrics data for GovWifi
resource "aws_s3_bucket" "metrics-data-bucket" {
  bucket        = "${var.Env-Name}-${lower(var.aws-region-name)}-metrics-data"
  force_destroy = true
  acl           = "private"

  tags = {
    Name   = "${title(var.Env-Name)} Internal Metrics data"
    Region = "${title(var.aws-region-name)}"
    Environment = "${title(var.Env-Name)}"
    Category    = "Statistics data"
  }

  versioning {
    enabled = true
  }
}
