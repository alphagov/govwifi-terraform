resource "aws_db_parameter_group" "db-parameters" {
  name        = "${var.Env-Name}-admin-db-parameter-group"
  family      = "mysql5.7"
  description = "DB parameter configuration for govwifi-admin"

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

  tags = {
    Name = "${title(var.Env-Name)} DB parameter group for govwifi-admin"
  }
}

resource "aws_db_option_group" "mariadb-audit" {
  name = "${var.Env-Name}-admin-db-audit"

  option_group_description = "Mariadb audit configuration for govwifi-admin"
  engine_name              = "mysql"
  major_engine_version     = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }

  tags = {
    Name = "${title(var.Env-Name)} DB Audit configuration for govwifi-admin"
  }
}

resource "aws_db_instance" "admin_db" {
  allocated_storage           = var.db-storage-gb
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = true
  instance_class              = var.db-instance-type
  identifier                  = "wifi-admin-${var.Env-Name}-db"
  name                        = "admin"
  username                    = var.admin-db-user
  password                    = var.admin-db-password
  backup_retention_period     = var.db-backup-retention-days
  multi_az                    = true
  storage_encrypted           = var.db-encrypt-at-rest
  db_subnet_group_name        = "wifi-${var.Env-Name}-subnets"
  vpc_security_group_ids      = [aws_security_group.admin-db-in.id]
  monitoring_role_arn         = var.rds-monitoring-role
  monitoring_interval         = var.db-monitoring-interval
  maintenance_window          = var.db-maintenance-window
  backup_window               = var.db-backup-window
  skip_final_snapshot         = true
  deletion_protection         = true

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  option_group_name               = aws_db_option_group.mariadb-audit.name
  parameter_group_name            = aws_db_parameter_group.db-parameters.name

  tags = {
    Name = "${title(var.Env-Name)} DB for govwifi-admin"
  }
}

resource "aws_cloudwatch_metric_alarm" "db_cpualarm" {
  alarm_name          = "${var.Env-Name}-admin-db-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"
  depends_on          = [aws_db_instance.admin_db]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.admin_db.identifier
  }

  alarm_description  = "This metric monitors the cpu utilization of the DB."
  alarm_actions      = [var.critical-notifications-arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_memoryalarm" {
  alarm_name          = "${var.Env-Name}-admin-db-memory-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "524288000"
  depends_on          = [aws_db_instance.admin_db]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.admin_db.identifier
  }

  alarm_description  = "This metric monitors the freeable memory available for the DB."
  alarm_actions      = [var.critical-notifications-arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_storagealarm" {
  alarm_name          = "${var.Env-Name}-admin-db-storage-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "16106127360"
  depends_on          = [aws_db_instance.admin_db]
  datapoints_to_alarm = "1"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.admin_db.identifier
  }

  alarm_description  = "This metric monitors the storage space available for the DB."
  alarm_actions      = [var.capacity-notifications-arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_burstbalancealarm" {
  alarm_name          = "${var.Env-Name}-admin-db-burstbalanace-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = "180"
  statistic           = "Minimum"
  threshold           = "45"
  depends_on          = [aws_db_instance.admin_db]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.admin_db.identifier
  }

  alarm_description  = "This metric monitors the IOPS burst balance available for the DB."
  alarm_actions      = [var.critical-notifications-arn]
  treat_missing_data = "missing"
}
