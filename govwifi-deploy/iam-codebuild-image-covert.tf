resource "aws_iam_role" "govwifi_codebuild_convert" {
  name = "govwifi-codebuild-convert-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "govwifi_codebuild_convert_staging_role_access_cloudwatch_policy" {
  name = "cloudwatch-logs-for-codepipeline-staging"
  path = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:eu-west-2:${local.aws_account_id}:log-group:govwifi-codebuild-convert-image-group",
                "arn:aws:logs:eu-west-2:${local.aws_account_id}:log-group:govwifi-codebuild-convert-image-group:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "govwifi_codebuild_convert_cloudwatch_policy" {
  name       = "codebuild-convert-cloudwatch-policy"
  roles      = [aws_iam_role.govwifi_codebuild_convert.name]
  policy_arn = aws_iam_policy.govwifi_codebuild_convert_staging_role_access_cloudwatch_policy.arn
}

resource "aws_iam_policy" "govwifi_codebuild_convert_service_policy" {
  name = "codebuild-convert-service-role"
  path = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:eu-west-2:${local.aws_account_id}:log-group:/aws/codebuild/govwifi-codebuild-convert-image-format",
                "arn:aws:logs:eu-west-2:${local.aws_account_id}:log-group:/aws/codebuild/govwifi-codebuild-convert-image-format:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
						"Action": [
							"s3:*"
						],
            "Resource": [
                "${aws_s3_bucket.codepipeline_bucket.arn}",
                "${aws_s3_bucket.codepipeline_bucket.arn}/*",
								"${aws_s3_bucket.codepipeline_bucket_ireland.arn}",
								"${aws_s3_bucket.codepipeline_bucket_ireland.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": [
                "arn:aws:codebuild:eu-west-2:${local.aws_account_id}:report-group/govwifi-codebuild-convert-image-format-*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "govwifi_codebuild_convert_service_role" {
  name       = "codebuild-convert-service-role"
  roles      = [aws_iam_role.govwifi_codebuild_convert.name]
  policy_arn = aws_iam_policy.govwifi_codebuild_convert_service_policy.arn
}
