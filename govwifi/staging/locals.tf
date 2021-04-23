locals {
  aws_account_id = jsondecode(data.aws_secretsmanager_secret_version.aws_account_id.secret_string)["account-id"]
}

locals {
  docker_image_path = jsondecode(data.aws_secretsmanager_secret_version.docker_image_path.secret_string)["docker-image-path"]
}