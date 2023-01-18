resource "aws_codepipeline" "alpaca_authentication_api_pipeline" {
  name     = "DEV-alpaca-authentication-api-pipeline"
  role_arn = aws_iam_role.govwifi_codepipeline_global_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
    region   = "eu-west-2"

    encryption_key {
      id   = aws_kms_key.codepipeline_key.arn
      type = "KMS"
    }
  }

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_ireland.bucket
    type     = "S3"
    region   = "eu-west-1"

    encryption_key {
      id   = aws_kms_key.codepipeline_key_ireland.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "NewECRImagDetectedFor-authentication-api"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = "govwifi/authentication-api/alpaca"
      }
    }
  }

  stage {
    name = "authentication-api-convert-imagedetail"

    action {
      name             = "authentication-api-convert-imagedetail"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["govwifi-build-authentication-api-convert-imagedetail-amended"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.govwifi_codebuild_project_convert_image_format["authentication-api"].name
      }
    }
  }

  stage {
    name = "Deploy-to-alpaca"

    action {
      name            = "Deploy-to-eu-west-2"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["govwifi-build-authentication-api-convert-imagedetail-amended"]
      version         = "1"
      region          = "eu-west-2"
      # This resource lives in the alpaca. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_alpaca_account_id}:role/govwifi-crossaccount-tools-deploy"

      configuration = {
        ClusterName : "alpaca-api-cluster"
        ServiceName : "authentication-api-service-alpaca"
      }
    }

    action {
      name            = "Deploy-to-eu-west-1"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["govwifi-build-authentication-api-convert-imagedetail-amended"]
      version         = "1"
      region          = "eu-west-1"
      # This resource lives in the alpaca. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_alpaca_account_id}:role/govwifi-crossaccount-tools-deploy"

      configuration = {
        ClusterName : "alpaca-api-cluster"
        ServiceName : "authentication-api-service-alpaca"
      }
    }
  }

  stage {
    name = "alpaca-Smoketests"

    action {
      name            = "alpaca-Smoketests"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      region          = "eu-west-2"
      input_artifacts = ["govwifi-build-authentication-api-convert-imagedetail-amended"]

      # This resource lives in the alpaca. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_alpaca_account_id}:role/govwifi-codebuild-role"
      version  = "1"

      configuration = {
        ProjectName = "govwifi-smoke-tests"
      }
    }
  }
}
