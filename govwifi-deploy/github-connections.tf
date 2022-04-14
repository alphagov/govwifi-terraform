resource "aws_codebuild_source_credential" "govwifi_github_token" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = jsondecode(data.aws_secretsmanager_secret_version.github_token.secret_string)["token"]
}

# # resource "aws_codestarconnections_connection" "github_connection" {
# #   name          = "govwifi-connection"
# #   provider_type = "GitHub"
# # }
