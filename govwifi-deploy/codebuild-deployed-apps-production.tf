resource "aws_codebuild_project" "govwifi_codebuild_project_push_image_to_ecr_production" {
  for_each      = toset(var.deployed_app_names)
  name          = "${each.key}-push-image-to-ecr-production"
  description   = "This project builds the API docker images and pushes them to ECR ${each.key}"
  build_timeout = "12"
  service_role  = aws_iam_role.govwifi_codebuild.arn

  artifacts {
    type                = "CODEPIPELINE"
    packaging           = "ZIP"
    encryption_disabled = true
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
      value = "production"
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

    environment_variable {
      name  = "APP"
      value = each.key
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

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec_production_deployed_image.yml")
  }

}
