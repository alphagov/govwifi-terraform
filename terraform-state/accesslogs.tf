# --------------------------------------------------------------
# Access logs
# --------------------------------------------------------------

resource "aws_iam_role" "accesslogs-replication" {
  name = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs-replication-role"

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

resource "aws_iam_policy" "accesslogs-replication" {
  name = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-accesslogs-replication-policy"

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
        "${aws_s3_bucket.accesslogs-bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.accesslogs-bucket.arn}/*"
      ]
    },
    {
      "Action": [
         "s3:ReplicateObject",
         "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${lower(var.product-name)}-${var.Env-Name}-${lower(var.backup-region-name)}-accesslogs/*"
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "accesslogs-replication" {
  name       = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-accesslogs-replication"
  roles      = [aws_iam_role.accesslogs-replication.name]
  policy_arn = aws_iam_policy.accesslogs-replication.arn
}

resource "aws_s3_bucket" "accesslogs-bucket" {
  bucket = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs"
  region = var.aws-region
  acl    = "log-delivery-write"

  tags = {
    Region      = title(var.aws-region-name)
    Product     = var.product-name
    Environment = title(var.Env-Name)
    Category    = "Accesslogs"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-accesslogs-lifecycle"
    enabled = true

    transition {
      days          = var.accesslogs-glacier-transition-days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.accesslogs-expiration-days
    }
  }

#  replication_configuration {
#    role = "${aws_iam_role.accesslogs-replication.arn}"
#
#    rules {
#      # ID is necessary to prevent continuous change issue
#      id     = "${lower(var.aws-region-name)}-to-${lower(var.backup-region-name)}-accesslogs-backup"
#      prefix = "${lower(var.aws-region-name)}-accesslogs-backup"
#      status = "Enabled"
#
#      destination {
#        bucket        = "arn:aws:s3:::${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.backup-region-name)}-accesslogs"
#        storage_class = "STANDARD"
#      }
#    }
#  }
}
