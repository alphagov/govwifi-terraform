# Resources for setting up s3 for terraform backend. (state storage in s3)
resource "aws_iam_role" "tfstate-replication" {
  name = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate-replication-role"

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

resource "aws_iam_policy" "tfstate-replication" {
  name = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate-replication-policy"

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
        "${aws_s3_bucket.state-bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.state-bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${lower(var.product-name)}-${var.Env-Name}-${lower(var.backup-region-name)}-tfstate/*"
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "tfstate-replication" {
  name       = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate-replication"
  roles      = [aws_iam_role.tfstate-replication.name]
  policy_arn = aws_iam_policy.tfstate-replication.arn
}

resource "aws_kms_key" "tfstate-key" {
  description             = "KMS key for the encryption of tfstate buckets."
  deletion_window_in_days = 10
  is_enabled              = true

  tags = {
    Region      = title(var.aws-region-name)
    Product     = var.product-name
    Environment = title(var.Env-Name)
    Category    = "TFstate"
  }
}

resource "aws_kms_alias" "tfstate-key-alias" {
  name          = "alias/${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate-key"
  target_key_id = aws_kms_key.tfstate-key.key_id
}

resource "aws_s3_bucket" "state-bucket" {
  bucket = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate"
  region = "${var.aws-region}"
  depends_on = ["aws_s3_bucket.accesslogs-bucket"]

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


  tags = {
    Region      = title(var.aws-region-name)
    Product     = var.product-name
    Environment = title(var.Env-Name)
    Category    = "TFstate"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-accesslogs"
    target_prefix = "${lower(var.aws-region-name)}-tfstate"
  }

#  replication_configuration {
#    role = "${aws_iam_role.tfstate-replication.arn}"
#
#    rules {
#      # ID is necessary to prevent continuous change issue
#      id     = "${lower(var.aws-region-name)}-to-${lower(var.backup-region-name)}-tfstate-backup"
#      prefix = "${lower(var.aws-region-name)}-tfstate"
#      status = "Enabled"
#
#      destination {
#        bucket        = "arn:aws:s3:::${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.backup-region-name)}-tfstate"
#        storage_class = "STANDARD_IA"
#      }
#    }
#  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.tfstate-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
