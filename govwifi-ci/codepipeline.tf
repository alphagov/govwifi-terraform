resource "aws_codepipeline" "govwifi_codepipeline" {
  for_each = toset(var.app_names)
  name     = "govwifi-deploy-pipeline"
  role_arn = aws_iam_role.govwifi_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.govwifi_codepipeline_bucket.bucket
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
        RepositoryName = "govwifi/${each.key}"
        ImageTag       = "staging"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      # output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.govwifi_codebuild_project_step_two[each.key].name
      }
    }
  }

}
