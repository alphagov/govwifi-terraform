provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "codebuild_terraform_logs" {

  bucket = "codebuild-terraform-logs"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_codebuild_project" "terraform_codebuild" {
  name        = "terraform-codebuild-project"
  description = "CodeBuild project for Terraform"
  service_role = aws_iam_role.govwifi_terraform_codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_terraform_logs.id}/build-log"
    }
  }

  secondary_sources {
    type            = "GITHUB"
    location        = "https://github.com/alphagov/govwifi-build.git"
    git_clone_depth = 1
    report_build_status = true
    source_identifier  = "govwifi_build"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/alphagov/govwifi-terraform.git"
    git_clone_depth = 1
    report_build_status = true

    buildspec = <<-EOF
      version: 0.2
      
      phases:
        pre_build:
          commands:
            - echo 'Installing Terraform'
            - wget https://releases.hashicorp.com/terraform/1.1.8/terraform_1.1.8_linux_amd64.zip
            - unzip terraform_1.1.8_linux_amd64.zip
            # - wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
            # - unzip terraform_1.5.7_linux_amd64.zip
            - mv terraform /usr/local/bin/
            - terraform --version
        build:
          commands:
            - echo 'Executing Terraform'
            - mv ../govwifi-build ./.private
            - pwd
            - export DEPLOY_ENV=tools
            - echo $DEPLOY_ENV
            - cd ./govwifi/$DEPLOY_ENV
            - pwd
            - terraform init
            - terraform plan -out=./tfplan.out
      EOF
  }
}

  # source {
  #   type            = "GITHUB"
  #   location        = "https://github.com/alphagov/govwifi-build.git"
  #   git_clone_depth = 1
  #   report_build_status = true
  # }

