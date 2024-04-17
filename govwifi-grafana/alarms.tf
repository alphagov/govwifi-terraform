resource "aws_cloudwatch_metric_alarm" "grafana_instance_status" {

  alarm_name         = "${var.env_name}-grafana-instance-status"
  alarm_description  = "Alert in event of ${var.env_name}-grafana EC2 on instance Status Check failure. Investigate Grafana CloudWatch logs for root cause."
  alarm_actions      = [var.capacity_notifications_arn]
  treat_missing_data = "breaching"

  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed_Instance"
  period              = "60"
  evaluation_periods  = "1"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"

  dimensions = {
    InstanceId = aws_instance.grafana_instance.id
  }

}

resource "aws_cloudwatch_metric_alarm" "grafana_system_status" {

  alarm_name         = "${var.env_name}-grafana-system-status"
  alarm_description  = "Alert in event of ${var.env_name}-grafana EC2 on system Status Check failure. Investigate Grafana CloudWatch logs for root cause."
  alarm_actions      = [
    var.capacity_notifications_arn
  ]
  treat_missing_data = "breaching"

  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed_System"
  period              = "60"
  evaluation_periods  = "1"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"

  dimensions = {
    InstanceId = aws_instance.grafana_instance.id
  }

}

resource "aws_cloudwatch_metric_alarm" "grafana_service_status" {

  alarm_name         = "${var.env_name}-grafana-service-status"
  alarm_description  = "Alert in event of ${var.env_name}-grafana can not load the login page. This likely indicates the Grafana service is not running."
  alarm_actions      = [var.capacity_notifications_arn]
  treat_missing_data = "breaching"

  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  period              = "60"
  evaluation_periods  = "1"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"

  dimensions = {
    TargetGroup      = aws_alb_target_group.grafana_tg.arn_suffix,
    AvailabilityZone = "${var.aws_region}a",
    LoadBalancer     = aws_lb.grafana_alb.arn_suffix
  }

}
