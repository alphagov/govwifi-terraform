resource "aws_codepipeline" "user_signup_api_pipeline" {
  name     = "user-signup-api-global-pipeline"
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
      name             = "NewECRImagDetectedFor-user-signup-api"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = "govwifi/user-signup-api"
      }
    }
  }

  stage {
    name = "user-signup-api-convert-imagedetail"

    action {
      name             = "user-signup-api-convert-imagedetail"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["govwifi-build-user-signup-api-convert-imagedetail-amended"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.govwifi_codebuild_project_convert_image_format["user-signup-api"].name
      }
    }
  }

  stage {
    name = "Deploy-to-Staging"

    action {
      name            = "Deploy-to-eu-west-2"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["govwifi-build-user-signup-api-convert-imagedetail-amended"]
      version         = "1"
      region          = "eu-west-2"
      # This resource lives in the Staging & Production environments. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-crossaccount-tools-deploy"

      configuration = {
        ClusterName : "staging-api-cluster"
        ServiceName : "user-signup-api-service-staging"
      }
    }

  }

  stage {
    name = "Staging-Smoketests"

    action {
      name            = "Staging-Smoketests"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      region          = "eu-west-2"
      input_artifacts = ["govwifi-build-user-signup-api-convert-imagedetail-amended"]

      # This resource lives in the Staging & Production environments. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-codebuild-role"
      version  = "1"

      configuration = {
        ProjectName = "govwifi-smoke-tests"
      }
    }
  }


  stage {
    name = "Release-to-PRODUCTION"

    action {
      name     = "Release-to-PRODUCTION"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      region   = "eu-west-2"
      version  = "1"
    }
  }


  stage {
    name = "PRODUCTION-Deploy"

    action {
      name            = "Deploy-to-eu-west-2-production"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["govwifi-build-user-signup-api-convert-imagedetail-amended"]
      version         = "1"
      region          = "eu-west-2"
      # This resource lives in the Staging & Production environments. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_production_account_id}:role/govwifi-crossaccount-tools-deploy"

      configuration = {
        ClusterName : "wifi-api-cluster"
        ServiceName : "user-signup-api-service-wifi"
      }
    }
  }

  stage {
    name = "Production-Smoketests"

    action {
      name            = "Production-Smoketests"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["govwifi-build-user-signup-api-convert-imagedetail-amended"]

      # This resource lives in the Staging & Production environments. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_production_account_id}:role/govwifi-codebuild-role"
      version  = "1"

      configuration = {
        ProjectName = "govwifi-smoke-tests"
      }
    }
  }


}
