resource "aws_iam_role" "govwifi_codepipeline_staging_role" {
  name               = "govwifi-codepipeline-staging-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# I think that this should just be delete and we have one role eventually
resource "aws_iam_role" "govwifi_codepipeline_production_role" {
  name               = "govwifi-codepipeline-production-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_staging_policy" {
  name = "govwifi-codepipeline-staging-policy"
  role = aws_iam_role.govwifi_codepipeline_staging_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
								"${aws_s3_bucket.codepipeline_bucket.arn}",
								"${aws_s3_bucket.codepipeline_bucket.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*"
        },
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-crossaccount-tools-deploy",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "govwifi_pipeline_staging_role_additional_policy" {
  name = "govwifi-additional-policy-for-codepipeline-staging"
  path = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "kms:GenerateDataKey",
            "Resource": "*"
        },
				{
						"Sid": "",
						"Effect": "Allow",
						"Action": "ecr:DescribeImages",
						"Resource": "*"
				}
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "govwifi_pipeline_staging_role_additional_policy" {
  name       = "govwifi-additional-policy-for-codepipeline-staging"
  roles      = [aws_iam_role.govwifi_codepipeline_staging_role.name]
  policy_arn = aws_iam_policy.govwifi_pipeline_staging_role_additional_policy.arn
}

resource "aws_iam_policy_attachment" "codepipeline_kms_power_user" {
  name       = "codepipeline-kms-power-user"
  roles      = [aws_iam_role.govwifi_codepipeline_staging_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"
}

resource "aws_iam_policy_attachment" "codepipeline_ecr_power_user" {
  name       = "codepipeline-ecr-power-user"
  roles      = [aws_iam_role.govwifi_codepipeline_staging_role.name, aws_iam_role.govwifi_codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
