resource "aws_codepipeline" "your-env-name_admin_pipeline" {
  name     = "DEV-your-env-name-admin-pipeline"
  role_arn = aws_iam_role.govwifi_codepipeline_global_role.arn

  artifact_store {
    region   = "eu-west-2"
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

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
      name             = "NewECRImagDetectedFor-admin"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = "govwifi/admin/your-env-name"
      }
    }
  }

  stage {
    name = "admin-convert-imagedetail"

    action {
      name             = "admin-convert-imagedetail"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["govwifi-build-admin-convert-imagedetail-amended"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.govwifi_codebuild_project_convert_image_format["admin"].name
      }
    }
  }

  stage {
    name = "Deploy-to-your-env-name"

    action {
      name            = "Deploy-to-eu-west-2"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["govwifi-build-admin-convert-imagedetail-amended"]
      version         = "1"
      # This resource lives in the your-env-name & Production environments. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_your-env-name_account_id}:role/govwifi-crossaccount-tools-deploy"

      configuration = {
        ClusterName : "your-env-name-admin-cluster"
        ServiceName : "admin-your-env-name"
      }
    }

  }

  stage {
    name = "your-env-name-Smoketests"

    action {
      name            = "your-env-name-Smoketests"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["govwifi-build-admin-convert-imagedetail-amended"]

      # This resource lives in the your-env-name & Production environments. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_your-env-name_account_id}:role/govwifi-codebuild-role"
      version  = "1"

      configuration = {
        ProjectName = "govwifi-smoke-tests"
      }
    }
  }

}
