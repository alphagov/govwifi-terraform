## Codebuild project one
## specify build file

resource "aws_codebuild_project" "govwifi_codebuild_project_step_one" {
  for_each = toset(var.app_names)
  name          = "govwifi-codebuild-${each.key}-step-one"
  description   = "Test codebuild project for the ${each.key}"
  build_timeout = "5"
  service_role  = aws_iam_role.govwifi_codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.govwifi_codepipeline_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true

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

  source_version = "codebuild-test"

  source {
    type = "GITHUB"
    location        = "https://github.com/alphagov/govwifi-user-signup-api.git"
    git_clone_depth = 1
    buildspec = "buildspec-build.yml"
  }

  #
  # tags = {
  #   Environment = "Test"
  # }
}

resource "aws_codebuild_source_credential" "govwifi_github_token" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_secretsmanager_secret_version.github_token.secret_string
}

resource "aws_codebuild_webhook" "govwifi_app_webhook" {
  # count  = length(var.app_names)
  for_each = toset(var.app_names)
  project_name = aws_codebuild_project.govwifi_codebuild_project_step_one[each.key].name
  build_type   = "BUILD"
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


## Codebuild project two
## Source ECR
## specify build two file

resource "aws_codebuild_project" "govwifi_codebuild_project_step_two" {
  for_each = toset(var.app_names)
  name          = "govwifi-codebuild-${each.key}-step-two"
  description   = "Test codebuild project for the ${each.key}"
  build_timeout = "5"
  service_role  = aws_iam_role.govwifi_codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.govwifi_codepipeline_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_REGION"
      value = "eu-west-2"
    }

    environment_variable {
      name  = "STAGE"
      value = "staging"
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "govwifi-codebuild-step-two-log-group"
      stream_name = "govwifi-codebuild-step-two-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.govwifi_codepipeline_bucket.id}/build-two-log"
    }
  }

  source_version = "codebuild-test"
  source {
    type = "GITHUB"
    location        = "https://github.com/alphagov/govwifi-user-signup-api.git"
    git_clone_depth = 1
    buildspec = "buildspec-deploy.yml"
  }


  # source_version = "refs/heads/codebuild-test"
  #
  #
  #
  # tags = {
  #   Environment = "Test"
  # }
}
