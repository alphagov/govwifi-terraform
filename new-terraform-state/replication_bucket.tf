locals {
  replication_bucket_name = "govwifi-${var.env_name}-tfstate-${data.aws_region.replication.name}"
}

resource "aws_s3_bucket" "replication_state_bucket" {
  provider = aws.replication

  bucket = local.replication_bucket_name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [{
    "Sid": "S3PolicyStmt-allow-all-s3-for-owner",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:*",
    "Resource": "arn:aws:s3:::${local.replication_bucket_name}/*",
    "Condition": {
      "StringEquals": {
        "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}",
        "s3:x-amz-acl": "bucket-owner-full-control"
      }
    }
  }]
}
EOF


  tags = {
    Region      = data.aws_region.replication.name
    Environment = title(var.env_name)
    Category    = "TFstate"
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}
