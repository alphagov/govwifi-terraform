locals {
  session_db_username = jsondecode(data.aws_secretsmanager_secret_version.session_db_credentials.secret_string)["username"]
}

locals {
  session_db_password = jsondecode(data.aws_secretsmanager_secret_version.session_db_credentials.secret_string)["password"]
}