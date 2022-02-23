resource "aws_cloudwatch_metric_alarm" "radius_healthcheck" {
  provider = aws.us_east_1
  count    = var.radius_instance_count
  alarm_name = "${element(
    aws_route53_health_check.radius.*.reference_name,
    count.index,
  )}-hc"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  treat_missing_data  = "breaching"

  dimensions = {
    HealthCheckId = element(aws_route53_health_check.radius.*.id, count.index)
  }

  alarm_actions = [
    var.us_east_1_critical_notifications_arn,
  ]

  alarm_description = "Route53 healthcheck request failed to authenticate via FreeRADIUS and Authentication API. Investigate CloudWatch logs for root cause."
}

resource "aws_cloudwatch_composite_alarm" "all_radius_servers_down" {
  provider   = aws.us_east_1
  alarm_name = "${var.env_name} ${var.aws_region} All Radius servers down"

  alarm_actions = [var.us_east_1_pagerduty_notifications_arn]

  alarm_rule = join(" AND ", formatlist("ALARM(\"%s\")", aws_cloudwatch_metric_alarm.radius_healthcheck[*].alarm_name))
}

resource "aws_cloudwatch_metric_alarm" "radius_latency" {
  provider = aws.us_east_1
  count    = var.radius_instance_count
  alarm_name = "${element(
    aws_route53_health_check.radius.*.reference_name,
    count.index,
  )}-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "TimeToFirstByte"
  namespace           = "AWS/Route53"
  period              = "120"
  statistic           = "Average"
  threshold           = "1000"

  dimensions = {
    HealthCheckId = element(aws_route53_health_check.radius.*.id, count.index)
  }

  alarm_actions = [
    var.us_east_1_critical_notifications_arn,
  ]

  alarm_description = "FreeRADIUS response rate is slow (greater than 1s). Investigate CloudWatch logs for root cause."
}

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

resource "aws_cloudwatch_metric_alarm" "shared_secret_is_incorrect" {
  alarm_name          = "Shared-secret-is-incorrect"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Shared-secret-is-incorrect"
  namespace           = "LogMetrics"
  period              = "86400"
  statistic           = "Sum"
  threshold           = "1.0"
  alarm_description   = "Newsite - RADIUS Shared secret entered incorrectly"

  alarm_actions = [var.critical_notifications_arn]
}
