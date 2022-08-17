resource "aws_codebuild_project" "govwifi_codebuild_project_push_image_to_ecr" {
  for_each      = toset(var.deployed_app_names)
  name          = "govwifi-codebuild-${each.key}-push-image-to-ecr"
  description   = "Test codebuild project for the ${each.key}"
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
    image                       = "aws/codebuild/standard:5.0"
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

    environment_variable {
      name  = "WORDLIST_BUCKET_NAME"
      value = "/govwifi-cd/pipelines/main/wordlist_bucket_name"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "ACCEPTANCE_TESTS_PROJECT_NAME"
      value = "govwifi-codebuild-acceptance-tests"
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

  source_version = "codebuild-test"

  source {
    type            = "GITHUB"
    location        = "https://github.com/alphagov/govwifi-${each.key}.git"
    git_clone_depth = 1
    buildspec       = "buildspec-build.yml"
  }

}

resource "aws_codebuild_webhook" "govwifi_app_webhook" {
  for_each     = toset(var.deployed_app_names)
  project_name = aws_codebuild_project.govwifi_codebuild_project_push_image_to_ecr[each.key].name

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


### This job converts the ECR image into a format usable by the ECS deploy stage
### more info here: https://stackoverflow.com/questions/61919191/how-to-deploy-to-ecs-when-an-image-is-pushed-to-ecr

resource "aws_codebuild_project" "govwifi_codebuild_project_convert_image_format" {
  for_each       = toset(var.deployed_app_names)
  name           = "govwifi-codebuild-convert-image-format-${each.key}"
  description    = "This job converts the ECR image into a format usable by the ECS deploy stage"
  build_timeout  = "5"
  service_role   = aws_iam_role.govwifi_codebuild_convert.arn
  encryption_key = aws_kms_key.codepipeline_key.arn

  artifacts {
    type      = "CODEPIPELINE"
    packaging = "ZIP"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
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


resource "aws_codebuild_project" "govwifi_codebuild_acceptance_tests" {
  name           = "govwifi-codebuild-acceptance-tests"
  description    = "This project runs the frontend acceptance tests"
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

  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/buildspec_acceptance_tests.yml")

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "govwifi-acceptance-tests-group"
      stream_name = "govwifi-acceptance-tests-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codepipeline_bucket.id}/acceptance-tests-log"
    }
  }

}
