resource "aws_codebuild_project" "govwifi_codebuild_project" {
  name          = "govwifi-codebuild-user-signup-api"
  description   = "Test codebuild project for the user-signup-api"
  build_timeout = "5"
  service_role  = aws_iam_role.govwifi_codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.govwifi_codepipeline_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "${var.aws_account_id}"
    }

    environment_variable {
      name  = "AWS_REGION"
      value = "eu-west-2"
    }

    environment_variable {
      name  = "STAGE"
      value = "staging"
    }

    environment_variable {
      name  = "DOCKER_HUB_AUTHTOKEN_ENV"
      value = "/govwifi-cd/pipelines/main/docker_hub_authtoken"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DOCKER_HUB_USERNAME_ENV"
      value = "/govwifi-cd/pipelines/main/docker_hub_username"
      type  = "PARAMETER_STORE"
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "govwifi-codepipeline-log-group"
      stream_name = "govwifi-codepipeline-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.govwifi_codepipeline_bucket.id}/build-log"
    }
  }

  source {
    type            = "CODEPIPELINE"
    # location        = "https://github.com/szd55gds/govwifi-user-signup-api.git"
    # git_clone_depth = 1
    #
    # git_submodules_config {
    #   fetch_submodules = true
    # }
  }

  # source_version = "codebuild-test"
  #
  #
  #
  # tags = {
  #   Environment = "Test"
  # }
}
