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

  dimensions = {
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

  dimensions = {
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

  dimensions = {
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

  dimensions = {
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

  dimensions = {
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
  threshold           = "30"

  dimensions = {
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

  dimensions = {
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

  dimensions = {
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

  dimensions = {
    DBInstanceIdentifier = "${aws_db_instance.read_replica.identifier}"
  }

  alarm_description  = "This metric monitors the storage space available for the DB read replica."
  alarm_actions      = ["${var.capacity-notifications-arn}"]
  treat_missing_data = "breaching"
}
