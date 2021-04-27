locals {
  users_db_username = jsondecode(data.aws_secretsmanager_secret_version.users_db_credentials.secret_string)["username"]
}

locals {
  users_db_password = jsondecode(data.aws_secretsmanager_secret_version.users_db_credentials.secret_string)["password"]
}