### This job converts the ECR image into a format usable by the ECS deploy stage
### more info here: https://stackoverflow.com/questions/61919191/how-to-deploy-to-ecs-when-an-image-is-pushed-to-ecr

resource "aws_codebuild_project" "govwifi_codebuild_project_convert_image_format" {
  for_each      = toset(var.deployed_app_names)
  name          = "${each.key}-convert-image-format"
  description   = "This job converts the ECR image into a format usable by the ECS deploy stage"
  build_timeout = "5"
  service_role  = aws_iam_role.govwifi_codebuild_convert.arn
  # encryption_key = aws_kms_key.codepipeline_key.arn

  artifacts {
    type                = "CODEPIPELINE"
    packaging           = "ZIP"
    encryption_disabled = true
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "CONTAINER_APP_NAME"
      value = each.key
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/build_spec_convert.yml")

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "govwifi-codebuild-convert-image-group"
      stream_name = "govwifi-codebuild-convert-image-group-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codepipeline_bucket.id}/image-convert-log"
    }
  }

}
