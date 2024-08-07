resource "aws_codebuild_project" "govwifi_codebuild_get_source_apps-dev" {
  name          = "TEST-admin-get-source"
  description   = "This project gets the source from git with default or given branch to trigger codepipeline for admin"
  build_timeout = "12"
  service_role  = aws_iam_role.govwifi_codebuild.arn

  artifacts {
    location  = aws_s3_bucket.codepipeline_bucket.bucket
    type      = "S3"
    path      = "/"
    packaging = "ZIP"
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
      name  = "SOURCE_BUCKET"
      value = aws_s3_bucket.codepipeline_bucket.bucket
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "govwifi-codebuild-get-source-log-group"
      stream_name = "govwifi-codebuild-get-source-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codepipeline_bucket.id}/build-log"
    }
  }

  source_version = "GW-1832_cb-cp_build_branch"

  source {
    type            = "GITHUB"
    location        = "https://github.com/alphagov/govwifi-admin.git"
    git_clone_depth = 1
    buildspec       = file("${path.module}/buildspec_build_source_apps.yml")
  }
}

resource "aws_codebuild_webhook" "govwifi_app_webhook_your-env-name" {

  project_name = aws_codebuild_project.govwifi_codebuild_get_source_apps-dev.name

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
