locals {
  bucket_name = "govwifi-${var.env_name}-tfstate-${data.aws_region.main.name}"
}

resource "aws_iam_role" "tfstate_replication" {
  name = "tfstate-replication"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

}

resource "aws_iam_policy" "tfstate_replication" {
  name = "tfstate-replication"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.state_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.state_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.replication_bucket_name}/*"
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "tfstate_replication" {
  name       = "tfstate-replication"
  roles      = [aws_iam_role.tfstate_replication.name]
  policy_arn = aws_iam_policy.tfstate_replication.arn
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = local.bucket_name

  tags = {
    Region   = data.aws_region.main.name
    Category = "TFstate"
  }
}

resource "aws_s3_bucket_public_access_block" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [{
    "Sid": "S3PolicyStmt-allow-all-s3-for-owner",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:*",
    "Resource": "arn:aws:s3:::${local.bucket_name}/*",
    "Condition": {
      "StringEquals": {
        "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}",
        "s3:x-amz-acl": "bucket-owner-full-control"
      }
    }
  }]
}
EOF
}

resource "aws_s3_bucket_replication_configuration" "state_bucket" {
  depends_on = [
    aws_s3_bucket_versioning.state_bucket,
    aws_s3_bucket_versioning.replication_state_bucket
  ]

  bucket = aws_s3_bucket.state_bucket.id
  role   = aws_iam_role.tfstate_replication.arn

  rule {
    id = "${lower(data.aws_region.main.name)}-to-${lower(data.aws_region.replication.name)}-tfstate-backup"

    filter {
      prefix = "${lower(data.aws_region.main.name)}-tfstate"
    }

    destination {
      bucket        = aws_s3_bucket.replication_state_bucket.arn
      storage_class = "STANDARD_IA"
    }

    delete_marker_replication {
      status = "Enabled"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  target_bucket = aws_s3_bucket.accesslogs_bucket.id
  target_prefix = "${var.env_name}-tfstate"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
