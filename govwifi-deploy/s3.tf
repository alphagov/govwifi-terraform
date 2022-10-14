resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "govwifi-codepipeline-bucket"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "codepipeline_bucket_policy" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "SSEAndSSLPolicy",
    "Statement": [
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
                "AWS": [
										"arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-crossaccount-tools-deploy",
										"arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-codebuild-role",
										"arn:aws:iam::${local.aws_production_account_id}:role/govwifi-crossaccount-tools-deploy",
										"${aws_iam_role.govwifi_codepipeline_global_role.arn}",
										"${aws_iam_role.govwifi_codebuild_convert.arn}"
									]
            },
            "Action": [
                "s3:*"
            ],
            "Resource": [
								"${aws_s3_bucket.codepipeline_bucket.arn}/*", "${aws_s3_bucket.codepipeline_bucket.arn}"
							]
        }
    ]
}
POLICY

}






resource "aws_s3_bucket" "codepipeline_bucket_ireland" {
  provider = aws.dublin
  bucket   = "govwifi-codepipeline-bucket-ireland"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl_ireland" {
  provider = aws.dublin
  bucket   = aws_s3_bucket.codepipeline_bucket_ireland.id
  acl      = "private"
}

resource "aws_s3_bucket_versioning" "destination" {
  provider = aws.dublin
  bucket   = aws_s3_bucket.codepipeline_bucket_ireland.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "codepipeline_bucket_policy_ireland" {
  provider = aws.dublin
  bucket   = aws_s3_bucket.codepipeline_bucket_ireland.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "SSEAndSSLPolicy",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
										"arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-crossaccount-tools-deploy",
										"arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-codebuild-role",
										"arn:aws:iam::${local.aws_production_account_id}:role/govwifi-crossaccount-tools-deploy",
										"${aws_iam_role.govwifi_codepipeline_global_role.arn}",
										"${aws_iam_role.govwifi_codebuild_convert.arn}"
									]
            },
            "Action": [
                "s3:*"
            ],
            "Resource": [
								"${aws_s3_bucket.codepipeline_bucket_ireland.arn}/*", "${aws_s3_bucket.codepipeline_bucket_ireland.arn}"
							]
        }
    ]
}
POLICY

}
