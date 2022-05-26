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
  name        = "GovwifiCodeBuildServiceRolePolicy"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogsPolicy",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CodeCommitPolicy",
            "Effect": "Allow",
            "Action": [
                "codecommit:GitPull"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3GetObjectPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3PutObjectPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ECRPullPolicy",
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ECRAuthPolicy",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3BucketIdentity",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        }
    ]
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

resource "aws_iam_policy_attachment" "codepipeline_ecr_poweruser" {
  name       = "codepipeline-ecr-poweruser"
  roles      = [aws_iam_role.govwifi_codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
