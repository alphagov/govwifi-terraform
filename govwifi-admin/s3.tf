resource "aws_s3_bucket" "admin_bucket" {
  count         = 1
  bucket        = "govwifi-${var.rails_env}-admin"
  force_destroy = true
  acl           = "private"

  tags = {
    Name        = "${title(var.env_name)} Admin data"
    Region      = title(var.aws_region_name)
    Environment = title(var.rails_env)
  }
}

resource "aws_s3_bucket_versioning" "admin_bucket" {
  bucket = aws_s3_bucket.admin_bucket[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "product_page_data_bucket" {
  count         = 1
  bucket        = "govwifi-${var.rails_env}-product-page-data"
  force_destroy = true
  acl           = "public-read"

  tags = {
    Name        = "${title(var.rails_env)} Product page data"
    Region      = title(var.aws_region_name)
    Environment = title(var.rails_env)
  }
}

resource "aws_s3_bucket_versioning" "product_page_data_bucket" {
  bucket = aws_s3_bucket.product_page_data_bucket[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "admin_mou_bucket" {
  count         = 1
  bucket        = "govwifi-${var.rails_env}-admin-mou"
  force_destroy = true
  acl           = "private"

  tags = {
    Name        = "${title(var.env_name)} MOU documents from Admin"
    Region      = title(var.aws_region_name)
    Environment = title(var.rails_env)
  }
}

resource "aws_s3_bucket_versioning" "admin_mou_bucket" {
  bucket = aws_s3_bucket.admin_mou_bucket[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "admin_bucket_policy" {
  bucket = aws_s3_bucket.admin_bucket[0].id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "AllowlistFetch",
  "Statement": [
    {
      "Sid": "Get Frontend Allowlist",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.admin_bucket[0].id}/clients.conf",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": [
            ${join(
  ",",
  formatlist(
    "\"%s\"",
    concat(
      var.london_radius_ip_addresses,
      var.dublin_radius_ip_addresses,
    ),
  ),
)}
          ]
        }
      }
    }
  ]
}
POLICY

}

resource "aws_s3_bucket_policy" "product_page_data_bucket_policy" {
  bucket = aws_s3_bucket.product_page_data_bucket[0].id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ProductPageDataFetch",
    "Statement": [
        {
            "Sid": "Get Product Page Data For Objects",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.product_page_data_bucket[0].id}/*"
        },
        {
            "Sid": "Get Product Page Data For Bucket",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetBucketVersioning",
                "s3:ListBucket",
                "s3:ListBucketVersions"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.product_page_data_bucket[0].id}"
        }
    ]
}
POLICY

}
