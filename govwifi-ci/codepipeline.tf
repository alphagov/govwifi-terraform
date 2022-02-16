resource "aws_codepipeline" "govwifi_codepipeline" {
  name     = "govwifi-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.govwifi_codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.govwifi_codestar_connection.arn
        FullRepositoryId = "szd55gds/govwifi-user-signup-api"
        BranchName       = "codebuild-test"
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
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "aws_codebuild_project.govwifi_codebuild_project.name"
      }
    }
  }

}

resource "aws_codestarconnections_connection" "govwifi_codestar_connection" {
  name          = "govwifi_codestarconnection"
  provider_type = "GitHub"
}
