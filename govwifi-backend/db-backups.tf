resource "aws_s3_bucket" "db_backups" {
  bucket        = "${var.Env-Name}-${lower(var.aws-region-name)}-db-backup"
  force_destroy = true
  acl           = "private"

  tags = {
    Name   = "${title(var.Env-Name)} Database backup"
    Region = "${title(var.aws-region-name)}"
    Environment = "${title(var.Env-Name)}"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "db_backups" {
  bucket = "${aws_s3_bucket.db_backups.id}"
  policy = "${data.aws_iam_policy_document.deny_delete_actions.json}"
}

data "aws_iam_policy_document" "deny_delete_actions" {
  statement {
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type = "AWS"
    }

    actions = [
      "s3:DeleteBucket",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.db_backups.arn}",
      "${aws_s3_bucket.db_backups.arn}/*"
    ]
  }
}


