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

resource "aws_db_parameter_group" "rr-parameters" {
  # No harm in keeping the parameter group even if there are no read replica(s) currently
  #count                    = "${var.db-instance-count}"
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

resource "aws_db_instance" "db" {
  count                       = "${var.db-instance-count}"
  allocated_storage           = "${var.db-storage-gb}"
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7.23"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = true
  instance_class              = "${var.db-instance-type}"
  identifier                  = "wifi-${var.Env-Name}-db"
  name                        = "govwifi_${var.Env-Name}"
  username                    = "${var.db-user}"
  password                    = "${var.db-password}"
  backup_retention_period     = "${var.db-backup-retention-days}"
  multi_az                    = true
  storage_encrypted           = "${var.db-encrypt-at-rest}"
  db_subnet_group_name        = "wifi-${var.Env-Name}-subnets"
  vpc_security_group_ids      = ["${var.db-sg-list}"]
  depends_on                  = ["aws_iam_role.rds-monitoring-role"]
  monitoring_role_arn         = "${aws_iam_role.rds-monitoring-role.arn}"
  monitoring_interval         = "${var.db-monitoring-interval}"
  maintenance_window          = "${var.db-maintenance-window}"
  backup_window               = "${var.db-backup-window}"
  skip_final_snapshot         = true

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  option_group_name               = "${aws_db_option_group.mariadb-audit.name}"
  parameter_group_name            = "${aws_db_parameter_group.db-parameters.name}"

  tags {
    Name = "${title(var.Env-Name)} DB"
  }
}

resource "aws_db_instance" "read_replica" {
  count                       = "${var.db-replica-count}"
  allocated_storage           = "${var.rr-storage-gb}"
  replicate_source_db         = "${aws_db_instance.db.identifier}"
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7.16"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = true
  instance_class              = "${var.rr-instance-type}"
  identifier                  = "${var.Env-Name}-db-rr"
  username                    = "${var.db-user}"
  password                    = "${var.db-password}"
  backup_retention_period     = 0
  multi_az                    = false
  storage_encrypted           = "${var.db-encrypt-at-rest}"
  vpc_security_group_ids      = ["${var.db-sg-list}"]
  depends_on                  = ["aws_iam_role.rds-monitoring-role"]
  monitoring_role_arn         = "${aws_iam_role.rds-monitoring-role.arn}"
  monitoring_interval         = "${var.db-monitoring-interval}"
  maintenance_window          = "${var.db-maintenance-window}"
  backup_window               = "${var.db-backup-window}"
  skip_final_snapshot         = true
  option_group_name           = "${aws_db_option_group.mariadb-audit.name}"
  parameter_group_name        = "${aws_db_parameter_group.rr-parameters.name}"

  tags {
    Name = "${title(var.Env-Name)} DB Read Replica"
  }
}

resource "aws_cloudwatch_metric_alarm" "db_cpualarm" {
  count               = "${var.db-instance-count}"
  alarm_name          = "${var.Env-Name}-db-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.db.identifier}"
  }

  alarm_description  = "This metric monitors the cpu utilization of the DB."
  alarm_actions      = ["${var.critical-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_memoryalarm" {
  count               = "${var.db-instance-count}"
  alarm_name          = "${var.Env-Name}-db-memory-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "524288000"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.db.identifier}"
  }

  alarm_description  = "This metric monitors the freeable memory available for the DB."
  alarm_actions      = ["${var.critical-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_storagealarm" {
  count               = "${var.db-instance-count}"
  alarm_name          = "${var.Env-Name}-db-storage-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "21474836480"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.db.identifier}"
  }

  alarm_description  = "This metric monitors the storage space available for the DB."
  alarm_actions      = ["${var.capacity-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_burstbalancealarm" {
  count               = "${var.db-instance-count}"
  alarm_name          = "${var.Env-Name}-db-burstbalanace-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = "180"
  statistic           = "Minimum"
  threshold           = "45"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.db.identifier}"
  }

  alarm_description  = "This metric monitors the IOPS burst balance available for the DB."
  alarm_actions      = ["${var.critical-notifications-arn}"]
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "rr_burstbalancealarm" {
  count               = "${var.db-replica-count}"
  alarm_name          = "${var.Env-Name}-rr-burstbalanace-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = "180"
  statistic           = "Minimum"
  threshold           = "45"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.read_replica.identifier}"
  }

  alarm_description  = "This metric monitors the IOPS burst balance available for the DB read replica."
  alarm_actions      = ["${var.capacity-notifications-arn}"]
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "rr_laggingalarm" {
  count               = "${var.db-replica-count}"
  alarm_name          = "${var.Env-Name}-rr-lagging-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "600"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.read_replica.identifier}"
  }

  alarm_description  = "This metric monitors the Replication Lag for the DB read replica."
  alarm_actions      = ["${var.capacity-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "rr_cpualarm" {
  count               = "${var.db-replica-count}"
  alarm_name          = "${var.Env-Name}-rr-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.read_replica.identifier}"
  }

  alarm_description  = "This metric monitors the cpu utilization of the DB read replica."
  alarm_actions      = ["${var.capacity-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "rr_memoryalarm" {
  count               = "${var.db-replica-count}"
  alarm_name          = "${var.Env-Name}-rr-memory-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "524288000"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.read_replica.identifier}"
  }

  alarm_description  = "This metric monitors the freeable memory available for the DB read replica."
  alarm_actions      = ["${var.capacity-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "rr_storagealarm" {
  count               = "${var.db-replica-count}"
  alarm_name          = "${var.Env-Name}-rr-storage-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "21474836480"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.read_replica.identifier}"
  }

  alarm_description  = "This metric monitors the storage space available for the DB read replica."
  alarm_actions      = ["${var.capacity-notifications-arn}"]
  treat_missing_data = "breaching"
}
