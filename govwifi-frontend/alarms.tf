resource "aws_cloudwatch_metric_alarm" "no_healthy_hosts" {
  alarm_name          = "${var.env_name} ${var.aws_region_name} frontend no healthy hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  datapoints_to_alarm = "1"

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
    TargetGroup  = aws_lb_target_group.main.arn_suffix
  }

  alarm_description = "Detect when there are no healthy frontend targets"

  alarm_actions = [
    var.critical_notifications_arn,
    var.pagerduty_notifications_arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "radius_cannot_connect_to_api" {
  alarm_name          = "${var.env_name}-${var.aws_region_name}-radius-cannot-connect-to-api"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 10
  evaluation_periods  = 5
  datapoints_to_alarm = 3
  period              = "60"
  statistic           = "Sum"
  treat_missing_data  = "missing"
  metric_name         = aws_cloudwatch_log_metric_filter.radius_cannot_connect_to_api.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.radius_cannot_connect_to_api.metric_transformation[0].namespace

  alarm_actions = [
    var.critical_notifications_arn
  ]

  alarm_description = "FreeRADIUS cannot connect to the Logging and/or Authentication API. Investigate CloudWatch logs for root cause."
}

resource "aws_cloudwatch_metric_alarm" "eap_outer_and_inner_identities_are_the_same" {
  alarm_name          = "${var.env_name}-${var.aws_region_name}-EAP Outer and inner identities are the same"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.outer_and_inner_identities_same.name
  namespace           = "LogMetrics"
  period              = "86400"
  statistic           = "Maximum"
  threshold           = "1.0"
  alarm_description   = "WLC using the real identity for the anonymous identity - Radius Missconfiguration"

  alarm_actions = [var.critical_notifications_arn]
}
