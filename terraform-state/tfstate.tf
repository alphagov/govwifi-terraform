# Resources for setting up s3 for terraform backend. (state storage in s3)
resource "aws_iam_role" "tfstate-replication" {
  name = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-tfstate-replication-role"

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
  name = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-tfstate-replication-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:ListBucket",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.state-bucket.arn}"
    },
    {
      "Action": "s3:GetReplicationConfiguration",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.state-bucket.arn}"
    },
    {
      "Action": "s3:GetObjectVersion",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.state-bucket.arn}/*"
    },
    {
      "Action": "s3:GetObjectVersionAcl",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.state-bucket.arn}/*"
    },
    {
      "Action": "s3:ReplicateObject",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${lower(var.product-name)}-${var.Env-Name}-${lower(var.backup-region-name)}-tfstate/*"
    },
    {
      "Action": "s3:ReplicateDelete",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${lower(var.product-name)}-${var.Env-Name}-${lower(var.backup-region-name)}-tfstate/*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "tfstate-replication" {
  name       = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-tfstate-replication"
  roles      = ["${aws_iam_role.tfstate-replication.name}"]
  policy_arn = "${aws_iam_policy.tfstate-replication.arn}"
}

resource "aws_s3_bucket" "state-bucket" {
  bucket = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-tfstate"
  region = "${var.aws-region}"

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

  tags {
    Region      = "${title(var.aws-region-name)}"
    Product     = "${var.product-name}"
    Environment = "${title(var.Env-Name)}"
    Category    = "TFstate"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs"
    target_prefix = "${lower(var.aws-region-name)}-tfstate"
  }

  replication_configuration {
    role = "${aws_iam_role.tfstate-replication.arn}"

    rules {
      # ID is necessary to prevent continuous change issue
      id     = "${lower(var.aws-region-name)}-to-${lower(var.backup-region-name)}-tfstate-backup"
      prefix = "${lower(var.aws-region-name)}-tfstate-backup"
      status = "Enabled"

      destination {
        bucket        = "arn:aws:s3:::${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.backup-region-name)}-tfstate"
        storage_class = "STANDARD"
      }
    }
  }
}

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
  name = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs-replication-policy"

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
  name       = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs-replication"
  roles      = ["${aws_iam_role.accesslogs-replication.name}"]
  policy_arn = "${aws_iam_policy.accesslogs-replication.arn}"
}

resource "aws_s3_bucket" "accesslogs-bucket" {
  bucket = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs"
  region = "${var.aws-region}"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  tags {
    Region      = "${title(var.aws-region-name)}"
    Product     = "${var.product-name}"
    Environment = "${title(var.Env-Name)}"
    Category    = "Accesslogs"
  }


  lifecycle_rule {
    id = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs-lifecycle"
    enabled = true

    transition {
      days          = 7
      storage_class = "GLACIER"
    }

    expiration {
      days                         = 30
    }
  }

  replication_configuration {
    role = "${aws_iam_role.accesslogs-replication.arn}"

    rules {
      # ID is necessary to prevent continuous change issue
      id     = "${lower(var.aws-region-name)}-to-${lower(var.backup-region-name)}-accesslogs-backup"
      prefix = "${lower(var.aws-region-name)}-accesslogs-backup"
      status = "Enabled"

      destination {
        bucket        = "arn:aws:s3:::${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.backup-region-name)}-accesslogs"
        storage_class = "STANDARD"
      }
    }
  }
}