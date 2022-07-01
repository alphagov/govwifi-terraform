resource "aws_iam_role" "govwifi_codebuild" {
  name = "govwifi-codebuild-role"

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


resource "aws_iam_policy" "govwifi_codebuild_role_policy" {
  name = "GovwifiCodeBuildServiceRolePolicy"
  path = "/"

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "CloudWatchLogsPolicy"
        },
        {
            "Action": [
                "codecommit:GitPull"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "CodeCommitPolicy"
        },
        {
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "S3GetObjectPolicy"
        },
        {
            "Action": [
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "S3PutObjectPolicy"
        },
        {
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "ECRPullPolicy"
        },
        {
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "ECRAuthPolicy"
        },
        {
            "Action": [
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "S3BucketIdentity"
        }
    ],
    "Version": "2012-10-17"
}
EOF

}

resource "aws_iam_policy_attachment" "govwifi_codebuild_role_policy" {
  name       = "govwifi-codebuild-role-policy"
  roles      = [aws_iam_role.govwifi_codebuild.name]
  policy_arn = aws_iam_policy.govwifi_codebuild_role_policy.arn
}


resource "aws_iam_policy_attachment" "codepipeline_ssm_readonly" {
  name       = "codepipeline-ssm-readonly"
  roles      = [aws_iam_role.govwifi_codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
