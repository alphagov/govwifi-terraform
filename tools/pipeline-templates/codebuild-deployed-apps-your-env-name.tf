resource "aws_codebuild_project" "govwifi_codebuild_project_push_image_to_ecr_your-env-name" {
  for_each      = toset(var.deployed_app_names)
  name          = "${each.key}-push-image-to-ecr-your-env-name"
  description   = "This project builds the API docker images and pushes them to ECR ${each.key}"
  build_timeout = "12"
  service_role  = aws_iam_role.govwifi_codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codepipeline_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = local.aws_account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = "eu-west-2"
    }

    environment_variable {
      name  = "STAGE"
      value = "your-env-name"
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

    environment_variable {
      name  = "WORDLIST_BUCKET_NAME"
      value = "/govwifi-cd/pipelines/main/wordlist_bucket_name"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "ACCEPTANCE_TESTS_PROJECT_NAME"
      value = "acceptance-tests"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "govwifi-codebuild-push-image-to-ecr-log-group"
      stream_name = "govwifi-codebuild-push-image-to-ecr-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codepipeline_bucket.id}/build-log"
    }
  }

  source_version = "master"


  source {
    type            = "GITHUB"
    location        = "https://github.com/alphagov/govwifi-${each.key}.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }
}

resource "aws_codebuild_webhook" "govwifi_app_webhook_your-env-name" {
  for_each = toset(var.deployed_app_names)

  project_name = aws_codebuild_project.govwifi_codebuild_project_push_image_to_ecr_your-env-name[each.key].name

  build_type = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_MERGED"
    }

    ### To test a branch without needing to raise a PR, uncomment the below and change source to the name of your branch
    # filter {
    #   type    = "HEAD_REF"
    #   pattern = "^refs/heads/buildspec-global-ecr$"
    # }
  }
}
