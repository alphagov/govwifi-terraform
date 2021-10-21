locals {
  session_db_username = jsondecode(data.aws_secretsmanager_secret_version.session_db_credentials.secret_string)["username"]
}

locals {
  session_db_password = jsondecode(data.aws_secretsmanager_secret_version.session_db_credentials.secret_string)["password"]
}

locals {
  users_db_username = jsondecode(data.aws_secretsmanager_secret_version.users_db_credentials.secret_string)["username"]
}

locals {
  users_db_password = jsondecode(data.aws_secretsmanager_secret_version.users_db_credentials.secret_string)["password"]
}

locals {
  rds_mysql_backup_bucket = var.backup_mysql_rds ? aws_s3_bucket.rds_mysql_backup_bucket[0].id : ""
}
