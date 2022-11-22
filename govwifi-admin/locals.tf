locals {
  admin_db_username = jsondecode(data.aws_secretsmanager_secret_version.admin_db.secret_string)["username"]

  admin_docker_image_new = "${data.aws_secretsmanager_secret_version.tools_account.secret_string}.dkr.ecr.${var.aws_region}.amazonaws.com/govwifi/admin/${var.env}:latest"
}

locals {
  admin_db_password = jsondecode(data.aws_secretsmanager_secret_version.admin_db.secret_string)["password"]
}
