# Resources for setting up s3 for terraform backend. (state storage in s3)
resource "aws_iam_role" "tfstate_replication" {
  name = "${lower(var.product_name)}-${lower(var.env_name)}-${lower(var.aws_region_name)}-tfstate-replication-role"

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
  name = "${lower(var.product_name)}-${lower(var.env_name)}-${lower(var.aws_region_name)}-tfstate-replication-policy"

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
      "Resource": "arn:aws:s3:::${lower(var.product_name)}-${var.env_name}-${lower(var.backup_region_name)}-tfstate/*"
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "tfstate_replication" {
  name       = "${lower(var.product_name)}-${lower(var.env_name)}-${lower(var.aws_region_name)}-tfstate-replication"
  roles      = [aws_iam_role.tfstate_replication.name]
  policy_arn = aws_iam_policy.tfstate_replication.arn
}

resource "aws_kms_key" "tfstate_key" {
  description             = "KMS key for the encryption of tfstate buckets."
  deletion_window_in_days = 10
  is_enabled              = true

  tags = {
    Region      = title(var.aws_region_name)
    Product     = var.product_name
    Environment = title(var.env_name)
    Category    = "TFstate"
  }
}

resource "aws_kms_alias" "tfstate_key_alias" {
  name          = "alias/${lower(var.product_name)}-${lower(var.env_name)}-${lower(var.aws_region_name)}-tfstate-key"
  target_key_id = aws_kms_key.tfstate_key.key_id
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "${lower(var.product_name)}-${lower(var.env_name)}-${lower(var.aws_region_name)}-tfstate"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [{
            "Sid": "S3PolicyStmt-allow-all-s3-for-owner",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${lower(var.product_name)}-${lower(var.env_name)}-${lower(var.aws_region_name)}-tfstate/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.aws_account_id}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
    }]
}
EOF


  tags = {
    Region      = title(var.aws_region_name)
    Product     = var.product_name
    Environment = title(var.env_name)
    Category    = "TFstate"
  }

  logging {
    target_bucket = "${lower(var.product_name)}-${lower(var.env_name)}-${lower(var.aws_region_name)}-accesslogs"
    target_prefix = "${lower(var.aws_region_name)}-tfstate"
  }

  replication_configuration {
    role = aws_iam_role.tfstate_replication.arn

    rules {
      # ID is necessary to prevent continuous change issue
      id     = "${lower(var.aws_region_name)}-to-${lower(var.backup_region_name)}-tfstate-backup"
      prefix = "${lower(var.aws_region_name)}-tfstate"
      status = "Enabled"

      destination {
        bucket        = "arn:aws:s3:::${lower(var.product_name)}-${lower(var.env_name)}-${lower(var.backup_region_name)}-tfstate"
        storage_class = "STANDARD_IA"
      }
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tfstate_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
