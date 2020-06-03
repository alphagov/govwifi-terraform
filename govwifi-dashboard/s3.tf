resource "aws_s3_bucket" "metrics-bucket" {
  bucket        = "metrics-bucket"
  force_destroy = true
  acl           = "private"

  tags = {
    Name        = "${title(var.Env-Name)} Metrics data"
  }

  versioning {
    enabled = true
  }
}

resource "aws_iam_role" "metrics-read-only-role" {
  name = "dashboard-metrics-read-only-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "metrics-read-only-policy" {
  name = "metrics-bucket-read-only-policy"
  role = aws_iam_role.metrics-read-only-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.metrics-bucket.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListObjectsV2",
        "s3:GetObject",
      ],
      "Resource": ["${aws_s3_bucket.metrics-bucket.arn}/*"]
    }
  ]
}
EOF
}

output "instance_ip_addr" {
  value = aws_s3_bucket.metrics-bucket.arn
}
