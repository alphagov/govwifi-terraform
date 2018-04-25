resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role-data-deletion"

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

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "ssm:GetParameters"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name       = "codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}

resource "aws_codebuild_project" "govwifi-data-deletion" {
  name         = "govwifi-data-deletion"
  description  = "govwifi_data_deletion"
  service_role = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/python:3.5.2",
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      "name"  = "SOME_KEY2"
      "value" = "SOME_VALUE2"
    }
  }

  source {
    type = "CODEPIPELINE"
  }

  tags {
    "Environment" = "Build"
  }
}
