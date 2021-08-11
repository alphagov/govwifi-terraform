locals {
  admin_db_username = jsondecode(data.aws_secretsmanager_secret_version.admin_db.secret_string)["username"]
}

locals {
  admin_db_password = jsondecode(data.aws_secretsmanager_secret_version.admin_db.secret_string)["password"]
}
