resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "govwifi-codepipeline-bucket"
}

resource "aws_s3_bucket_policy" "codepipeline_bucket_policy" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "SSEAndSSLPolicy",
    "Statement": [
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.codepipeline_bucket.arn}/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "aws:kms"
                }
            }
        },
        {
            "Sid": "DenyInsecureConnections",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.codepipeline_bucket.arn}/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-crossaccount-tools-deploy"
            },
            "Action": [
                "s3:Get*",
                "s3:Put*"
            ],
            "Resource": "${aws_s3_bucket.codepipeline_bucket.arn}/*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-crossaccount-tools-deploy"
            },
            "Action": "s3:ListBucket",
            "Resource": "${aws_s3_bucket.codepipeline_bucket.arn}"
        }
    ]
}
POLICY

}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}
