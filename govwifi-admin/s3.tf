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

resource "aws_s3_bucket" "admin-mou-bucket" {
  count         = 1
  bucket        = "govwifi-${var.rack-env}-admin-mou"
  force_destroy = true
  acl           = "private"

  tags {
    Name        = "${title(var.Env-Name)} MOU documents from Admin"
    Region      = "${title(var.aws-region-name)}"
    Environment = "${title(var.rack-env)}"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "admin-bucket-policy" {
  bucket = "${aws_s3_bucket.admin-bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "WhitelistFetch",
  "Statement": [
    {
      "Sid": "Get Frontend Whitelist",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::govwifi-${var.rack-env}-admin/clients.conf",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": [
            ${join(",", formatlist("\"%s\"", concat(var.london-radius-ip-addresses, var.dublin-radius-ip-addresses)))}
          ]
        }
      }
    }
  ]
}
POLICY
}
