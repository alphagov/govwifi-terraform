resource "aws_cloudwatch_metric_alarm" "radius_cannot_connect_to_api" {
  alarm_name          = "${var.env_name}-radius-cannot-connect-to-api"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 2
  period              = "60"
  statistic           = "Sum"
  treat_missing_data  = "breaching"
  metric_name         = aws_cloudwatch_log_metric_filter.radius_cannot_connect_to_api.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.radius_cannot_connect_to_api.metric_transformation[0].namespace

  alarm_actions = [
    var.critical_notifications_arn,
  ]

  alarm_description = "FreeRADIUS cannot connect to the Logging and/or Authentication API. Investigate CloudWatch logs for root cause."
}

resource "aws_cloudwatch_metric_alarm" "eap_outer_and_inner_identities_are_the_same" {
  alarm_name          = "EAP Outer and inner identities are the same"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.outer_and_inner_identities_same.name
  namespace           = "LogMetrics"
  period              = "86400"
  statistic           = "Maximum"
  threshold           = "1.0"
  alarm_description   = "WLC using the real identity for the anonymous identity"

  alarm_actions = [var.critical_notifications_arn]
}
