resource "aws_codepipeline" "codepipeline" {
  for_each = toset(var.app_names)
  name     = "govwifi-deploy-${each.key}-staging-pipeline"
  role_arn = aws_iam_role.govwifi_codepipeline_staging_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "NewECRImagDetectedFor-${each.key}"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = "govwifi/staging/${each.key}"
      }
    }
  }

  stage {
    name = "govwifi-build-${each.key}-convert-imagedetail"

    action {
      name             = "govwifi-build-${each.key}-convert-imagedetail"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["govwifi-build-${each.key}-convert-imagedetail-amended"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.govwifi_codebuild_project_convert_image_format[each.key].name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["govwifi-build-${each.key}-convert-imagedetail-amended"]
      version         = "1"
      region          = "eu-west-2"
      # This resource lives in the Staging & Production environments. It will always have to
      # either be hardcoded or retrieved from the AWS secrets or parameter store
      role_arn = "arn:aws:iam::${local.aws_staging_account_id}:role/govwifi-crossaccount-tools-deploy"

      configuration = {
        ClusterName : each.key == "admin" ? "staging-admin-cluster" : "staging-api-cluster"
        ServiceName : each.key == "admin" ? "admin-staging" : "${each.key}-service-staging"
      }
    }
  }
}
