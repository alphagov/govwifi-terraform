resource "aws_codebuild_project" "govwifi_codebuild_saferestarter" {
  name           = "govwifi-build-safe-restarter"
  description    = "This project builds the safe-restarter image and pushes it to ECR"
  build_timeout  = "5"
  service_role   = aws_iam_role.govwifi_codebuild.arn
  encryption_key = aws_kms_key.codepipeline_key.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "DOCKER_HUB_AUTHTOKEN_ENV"
      value = data.aws_secretsmanager_secret_version.docker_hub_authtoken.secret_string
    }

    environment_variable {
      name  = "DOCKER_HUB_USERNAME_ENV"
      value = data.aws_secretsmanager_secret_version.docker_hub_username.secret_string
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = local.aws_account_id
    }

    environment_variable {
      name  = "STAGE"
      value = "staging"
    }

    environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.safe_restarter_ecr.name
    }


  }

  source_version = "codebuild-test"

  source {
    type            = "GITHUB"
    location        = "https://github.com/alphagov/govwifi-safe-restarter.git"
    git_clone_depth = 1
    buildspec       = "buildspec-build.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "govwifi-safe-restarter-group"
      stream_name = "govwifi-safe-restarter-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codepipeline_bucket.id}/safe-restarter-log"
    }
  }

}

resource "aws_codebuild_webhook" "govwifi_saferestarter_webhook" {
  project_name = aws_codebuild_project.govwifi_codebuild_saferestarter.name

  build_type = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "^refs/heads/codebuild-test$"
    }
  }
}
