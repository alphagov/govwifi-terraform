resource "aws_db_subnet_group" "db-subnets" {
  name        = "wifi-${var.Env-Name}-subnets"
  description = "GovWifi ${var.Env-Name} backend subnets"
  subnet_ids  = ["${aws_subnet.wifi-backend-subnet.*.id}"]

  tags {
    Name = "wifi-${var.Env-Name}-subnets"
  }
}

resource "aws_db_parameter_group" "db-parameters" {
  count       = "${var.db-instance-count}"
  name        = "${var.Env-Name}-db-parameter-group"
  family      = "mysql5.7"
  description = "DB parameter configuration"

  parameter {
    name  = "slow_query_log"
    value = 1
  }

  parameter {
    name  = "general_log"
    value = 0
  }

  parameter {
    name  = "log_queries_not_using_indexes"
    value = 1
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  tags {
    Name = "${title(var.Env-Name)} DB parameter group"
  }
}

resource "aws_db_parameter_group" "user-db-parameters" {
  count       = "${var.db-instance-count}"
  name        = "${var.Env-Name}-user-db-parameter-group"
  family      = "mysql8.0"
  description = "User DB parameter configuration"

  parameter {
    name  = "slow_query_log"
    value = 1
  }

  parameter {
    name  = "general_log"
    value = 0
  }

  parameter {
    name  = "log_queries_not_using_indexes"
    value = 1
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  tags {
    Name = "${title(var.Env-Name)} User DB parameter group"
  }
}

resource "aws_db_parameter_group" "rr-parameters" {
  name = "${var.Env-Name}-rr-parameter-group"

  family      = "mysql5.7"
  description = "DB read replica parameter configuration"

  parameter {
    name  = "slow_query_log"
    value = 1
  }

  parameter {
    name  = "general_log"
    value = 0
  }

  parameter {
    name  = "log_queries_not_using_indexes"
    value = 1
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  tags {
    Name = "${title(var.Env-Name)} DB read replica parameter group"
  }
}

resource "aws_db_option_group" "mariadb-audit" {
  # No harm in keeping the parameter group even if there is DB instance currently
  #count                    = "${var.db-instance-count}"
  name = "${var.Env-Name}-db-audit"

  option_group_description = "Mariadb audit configuration"
  engine_name              = "mysql"
  major_engine_version     = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }

  tags {
    Name = "${title(var.Env-Name)} DB Audit configuration"
  }
}

resource "aws_db_option_group" "user-mariadb-audit" {
  count       = "${var.db-instance-count}"
  name = "${var.env}-user-db-audit"

  option_group_description = "Mariadb audit configuration"
  engine_name              = "mysql"
  major_engine_version     = "8.0"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }

  tags {
    Name = "${title(var.env)} User DB Audit configuration"
  }
}
