resource "aws_cloudwatch_metric_alarm" "grafana-instance-status" {

  alarm_name         = "${var.Env-Name}-grafana-instance-status"
  alarm_description  = "Alert in event of ${var.Env-Name}-granfana EC2 on instance Status Check failure"
  alarm_actions      = [var.critical-notifications-arn]
  treat_missing_data = "breaching"

  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed_Instance"
  period              = "60"
  evaluation_periods  = "1"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"

  dimensions = {
    InstanceId = aws_instance.grafana_instance.*.id[0]
  }

}

resource "aws_cloudwatch_metric_alarm" "grafana-system-status" {

  alarm_name         = "${var.Env-Name}-grafana-system-status"
  alarm_description  = "Alert in event of ${var.Env-Name}-granfana EC2 on system Status Check failure"
  alarm_actions      = [var.critical-notifications-arn]
  treat_missing_data = "breaching"

  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed_System"
  period              = "60"
  evaluation_periods  = "1"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"

  dimensions = {
    InstanceId = aws_instance.grafana_instance.*.id[0]
  }

}
