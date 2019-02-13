resource "aws_s3_bucket" "wordlist" {
  bucket = "govwifi-wordlist"
  count  = "${var.wordlist-bucket-count}"
  acl    = "private"

  tags {
    Name = "wordlist-bucket"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "wordlist" {
  bucket = "${aws_s3_bucket.wordlist.bucket}"
  count  = "${var.wordlist-bucket-count}"
  key    = "wordlist-short"
  source = "${var.wordlist-file-path}"
  etag   = "${md5(file(var.wordlist-file-path))}"
}

resource "aws_iam_user_policy" "jenkins-read-wordlist-policy" {
  user   = "${aws_iam_user.jenkins-read-wordlist-bucket.name}"
  name   = "jenkins-read-wordlist-policy"
  count  = "${var.wordlist-bucket-count}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.wordlist.bucket}/${aws_s3_bucket_object.wordlist.key}"
    }
  ]
}
EOF
}

resource "aws_iam_user" "jenkins-read-wordlist-bucket" {
  name  = "jenkins-read-wordlist-user"
  count = "${var.wordlist-bucket-count}"
}
