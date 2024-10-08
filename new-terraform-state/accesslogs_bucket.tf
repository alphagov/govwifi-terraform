locals {
  accesslogs_bucket_name = "govwifi-${var.env_name}-accesslogs-${data.aws_region.main.name}"
}

resource "aws_iam_role" "accesslogs_replication" {
  name = "govwifi-${var.env_name}-accesslogs-replication-role"

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

resource "aws_iam_policy" "accesslogs_replication" {
  name = "govwifi-${var.env_name}-accesslogs-replication-policy"

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
        "${aws_s3_bucket.accesslogs_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.accesslogs_bucket.arn}/*"
      ]
    },
    {
      "Action": [
         "s3:ReplicateObject",
         "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.replication_accesslogs_bucket.arn}/*"
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "accesslogs_replication" {
  name       = "govwifi-${var.env_name}-accesslogs-replication"
  roles      = [aws_iam_role.accesslogs_replication.name]
  policy_arn = aws_iam_policy.accesslogs_replication.arn
}

resource "aws_s3_bucket" "accesslogs_bucket" {
  bucket = local.accesslogs_bucket_name

  tags = {
    Region   = data.aws_region.main.name
    Category = "Accesslogs"
  }
}

resource "aws_s3_bucket_public_access_block" "accesslogs_bucket" {
  bucket = aws_s3_bucket.accesslogs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_replication_configuration" "accesslogs_replication" {
  depends_on = [
    aws_s3_bucket_versioning.accesslogs_bucket,
    aws_s3_bucket_versioning.replication_accesslogs_bucket
  ]

  bucket = aws_s3_bucket.accesslogs_bucket.id
  role   = aws_iam_role.accesslogs_replication.arn

  rule {
    id = "${data.aws_region.main.name}-to-${data.aws_region.replication.name}-accesslogs-backup"

    filter {
      prefix = "${var.env_name}-accesslogs-backup"
    }

    destination {
      bucket        = aws_s3_bucket.replication_accesslogs_bucket.arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "accesslogs_bucket" {
  bucket = aws_s3_bucket.accesslogs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "accesslogs_bucket" {
  bucket = aws_s3_bucket.accesslogs_bucket.id
  acl    = "log-delivery-write"

  depends_on = [aws_s3_bucket_ownership_controls.accesslogs_bucket]
}

resource "aws_s3_bucket_versioning" "accesslogs_bucket" {
  bucket = aws_s3_bucket.accesslogs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "accesslogs_bucket" {
  depends_on = [aws_s3_bucket_versioning.accesslogs_bucket]

  bucket = aws_s3_bucket.accesslogs_bucket.id

  rule {
    id = "accesslogs-lifecycle"

    transition {
      days          = var.accesslogs_glacier_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.accesslogs_expiration_days
    }

    status = "Enabled"
  }
}
