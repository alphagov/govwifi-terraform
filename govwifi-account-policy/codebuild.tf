resource "aws_codebuild_project" "iam_management" {
  count         = (var.aws_region == "eu-west-2" ? 1 : 0)
  name          = "govwifi-disable-inactive-IAM-keys"
  description   = "This project disables IAM user keys that have not been used in over 45 days"
  build_timeout = "5"
  service_role  = aws_iam_role.iam_management[0].arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/buildspec.yml")

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "govwifi-iam-user-managment-script-log"
      stream_name = "govwifi-iam-user-managment-script-log"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.iam_user_managment_logs.id}/govwifi-iam-user-managment-log"
    }
  }

}

# Trigger inactive users check to run every 30 days
resource "aws_cloudwatch_event_target" "check_inactive_iam_users" {
  count = (var.aws_region == "eu-west-2" ? 1 : 0)
  rule  = aws_cloudwatch_event_rule.check_inactive_iam_users[0].name
  arn   = aws_codebuild_project.iam_management[0].id

  role_arn = aws_iam_role.iam_management[0].arn
}

# Runs on the 30th day of every month at 10:30
resource "aws_cloudwatch_event_rule" "check_inactive_iam_users" {
  count               = (var.aws_region == "eu-west-2" ? 1 : 0)
  name                = "check-inactive-iam-users"
  schedule_expression = "cron(30 10 28 * ? *)"
}