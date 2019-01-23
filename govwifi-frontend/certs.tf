resource "aws_s3_bucket" "frontend-cert-bucket" {
  count         = 1
  bucket        = "govwifi-${var.rack-env}-frontend-cert"
  acl           = "private"

  tags {
    Name        = "${title(var.Env-Name)} Frontend certs"
    Region      = "${title(var.aws-region-name)}"
    Environment = "${title(var.rack-env)}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

data "aws_iam_policy_document" "frontend-cert-bucket-policy-document" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.frontend-cert-bucket.arn}/*"
    ]
    principals = [
      "${aws_instance.radius.*.arn}"
    ]
  }
}

resource "aws_s3_bucket_policy" "frontend-cert-bucket-policy" {
  bucket = "${aws_s3_bucket.frontend-cert-bucket.id}"
  policy = "${data.aws_iam_policy_document.frontend-cert-bucket-policy-document.json}"
}
