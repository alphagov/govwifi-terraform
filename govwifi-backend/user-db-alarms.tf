resource "aws_cloudwatch_metric_alarm" "user_db_cpu_alarm" {
  count               = var.db-instance-count
  alarm_name          = "${var.env}-user-db-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.users_db[0].identifier
  }

  alarm_description  = "Database CPU utilization exceeding threshold. Investigate database logs for root cause."
  alarm_actions      = [var.critical-notifications-arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "user_db_memory" {
  count               = var.db-instance-count
  alarm_name          = "${var.env}-user-db-memory-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "524288000"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.users_db[0].identifier
  }

  alarm_description  = "Database is running low on free memory. Investigate database logs for root cause."
  alarm_actions      = [var.critical-notifications-arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "user_db_storage" {
  count               = var.db-instance-count
  alarm_name          = "${var.env}-user-db-storage-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = var.db-storage-alarm-threshold
  datapoints_to_alarm = "1"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.users_db[0].identifier
  }

  alarm_description  = "Database is running low on free storage space. Investigate database logs for root cause."
  alarm_actions      = [var.capacity-notifications-arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "user_rr_burst_balance" {
  count               = var.user-db-replica-count
  alarm_name          = "${var.env}-user-rr-burstbalanace-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = "180"
  statistic           = "Minimum"
  threshold           = "45"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.users_read_replica[0].identifier
  }

  alarm_description  = "Read replica database's available IOPS burst balance is running low. Investigate disk usage on the RDS instance."
  alarm_actions      = [var.capacity-notifications-arn]
  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "user_rr_lagging" {
  count               = var.user-db-replica-count
  alarm_name          = "${var.env}-user-rr-lagging-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "600"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.users_read_replica[0].identifier
  }

  alarm_description  = "Read replica database replication lag exceeding threshold. Investigate connections to the primary database."
  alarm_actions      = [var.capacity-notifications-arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "user_rr_cpu" {
  count               = var.user-db-replica-count
  alarm_name          = "${var.env}-user-rr-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.users_read_replica[0].identifier
  }

  alarm_description  = "Read replica database CPU utilization exceeding threshold. Investigate database logs for root cause."
  alarm_actions      = [var.capacity-notifications-arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "user_rr_memory" {
  count               = var.user-db-replica-count
  alarm_name          = "${var.env}-user-rr-memory-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "524288000"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.users_read_replica[0].identifier
  }

  alarm_description  = "Read replica database is running low on free memory. Investigate database logs for root cause."
  alarm_actions      = [var.capacity-notifications-arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "user_rr_storage" {
  count               = var.user-db-replica-count
  alarm_name          = "${var.env}-user-rr-storage-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "16106127360"
  datapoints_to_alarm = "1"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.users_read_replica[0].identifier
  }

  alarm_description  = "Read replica database is running low on free storage space. Investigate database logs for root cause."
  alarm_actions      = [var.capacity-notifications-arn]
  treat_missing_data = "breaching"
}

