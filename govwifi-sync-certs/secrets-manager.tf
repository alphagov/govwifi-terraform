data "aws_secretsmanager_secret_version" "docker_hub_authtoken" {
  secret_id = data.aws_secretsmanager_secret.docker_hub_authtoken.id
}

data "aws_secretsmanager_secret" "docker_hub_authtoken" {
  name = "deploy/docker_hub_authtoken"
}

data "aws_secretsmanager_secret_version" "docker_hub_username" {
  secret_id = data.aws_secretsmanager_secret.docker_hub_username.id
}

data "aws_secretsmanager_secret" "docker_hub_username" {
  name = "deploy/docker_hub_username"
}

data "aws_secretsmanager_secret_version" "gpg_fingerprint" {
  secret_id = data.aws_secretsmanager_secret.gpg_fingerprint.id
}

data "aws_secretsmanager_secret" "gpg_fingerprint" {
  name = "deploy/gpg_fingerprint"
}

data "aws_secretsmanager_secret_version" "gpg_key" {
  secret_id = data.aws_secretsmanager_secret.gpg_key.id
}

data "aws_secretsmanager_secret" "gpg_key" {
  name = "deploy/gpg_key"
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

data "aws_secretsmanager_secret" "github_token" {
  name = "github/deployment-user"
}