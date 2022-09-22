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


resource "aws_iam_policy" "govwifi_codebuild_vpc_policy" {
  name = "GovwifiVPC"
  path = "/"

  policy = <<EOF
{
	"Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": "arn:aws:ec2:eu-west-2:${var.aws_account_id}:network-interface/*",
      "Condition": {
        "StringEquals": {
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        },
        "ArnEquals": {
          "ec2:Subnet": [
            "arn:aws:ec2:eu-west-2:${var.aws_account_id}:subnet/${aws_subnet.smoke_tests_private_a.id}",
            "arn:aws:ec2:eu-west-2:${var.aws_account_id}:subnet/${aws_subnet.smoke_tests_private_b.id}"
          ]
        }
      }
    }
  ]
}
EOF

}


resource "aws_iam_policy_attachment" "codebuild_vpc" {
  name       = "govwifi-codebuild-vpc"
  roles      = [aws_iam_role.govwifi_codebuild.name]
  policy_arn = aws_iam_policy.govwifi_codebuild_vpc_policy.arn
}

resource "aws_iam_policy_attachment" "codepipeline_ssm_readonly" {
  name       = "codepipeline-ssm-readonly"
  roles      = [aws_iam_role.govwifi_codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "codebuild_start_build_perm" {
  name       = "codebuild-startbuild-perm"
  roles      = [aws_iam_role.govwifi_codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}
