resource "aws_iam_user_policy" "dashboard-read-only-policy" {
  user = "${aws_iam_user.dashboard-read-only-user.name}"
  name = "dashboard-${var.Env-Name}-read-only-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.metrics-bucket.bucket}/*"
    },
    {
      "Action": [
        "s3:ListObjectsV2"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.metrics-bucket.bucket}"
    }
  ]
}
EOF
}

resource "aws_iam_user" "dashboard-read-only-user" {
  name = "dashboard-${var.Env-Name}-read-only-user"
}
