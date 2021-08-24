resource "aws_cloudwatch_metric_alarm" "grafana-instance-status" {

  alarm_name         = "${var.Env-Name}-grafana-instance-status"
  alarm_description  = "Alert in event of ${var.Env-Name}-grafana EC2 on instance Status Check failure. Investigate Grafana CloudWatch logs for root cause."
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
  alarm_description  = "Alert in event of ${var.Env-Name}-grafana EC2 on system Status Check failure. Investigate Grafana CloudWatch logs for root cause."
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

resource "aws_cloudwatch_metric_alarm" "grafana-service-status" {

  alarm_name         = "${var.Env-Name}-grafana-service-status"
  alarm_description  = "Alert in event of ${var.Env-Name}-grafana can not load the login page. This likely indicates the Grafana service is not running."
  alarm_actions      = [var.critical-notifications-arn]
  treat_missing_data = "breaching"

  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  period              = "60"
  evaluation_periods  = "1"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"

  dimensions = {
    TargetGroup      = aws_alb_target_group.grafana-tg.arn_suffix,
    AvailabilityZone = "${var.aws-region}a",
    LoadBalancer     = aws_lb.grafana-alb.arn_suffix
  }

}
