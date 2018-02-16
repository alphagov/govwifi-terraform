# Resources for setting up s3 for terraform backend. (state storage in s3)
resource "aws_s3_bucket" "state-bucket" {
  bucket = "govwifi-${var.Env-Name}-${lower(var.aws-region-name)}-tfstate"
  region = "${var.aws-region}"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = "govwifi-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs"
    target_prefix = "${lower(var.aws-region-name)}-tfstate"
  }
  tags {
    Region      = "${title(var.aws-region-name)}"
    Product     = "${var.product-name}"
    Environment = "${title(var.Env-Name)}"
    Category    = "TFstate"
  }


  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [{
            "Sid": "S3PolicyStmt-allow-all-s3-for-owner",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.aws-account-id}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
    }]
}
EOF

}

resource "aws_s3_bucket" "accesslogs-bucket" {
  bucket = "govwifi-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs"
  versioning {
    enabled = true
  }
  tags {
    Region      = "${title(var.aws-region-name)}"
    Product     = "${var.product-name}"
    Environment = "${title(var.Env-Name)}"
    Category    = "Accesslogs"
  }
  region      = "${var.aws-region}"
}