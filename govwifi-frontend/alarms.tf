# TODO This resource can be removed after the switch to the NLBs
resource "aws_cloudwatch_metric_alarm" "radius_healthcheck" {
  for_each = {
    for az, subnet
    in aws_subnet.wifi_frontend_subnet :
    index(data.aws_availability_zones.zones.names, az) => subnet.id
  }

  provider            = aws.us_east_1
  alarm_name          = "${aws_route53_health_check.radius[each.key].reference_name}-hc"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  treat_missing_data  = "breaching"

  dimensions = {
    HealthCheckId = aws_route53_health_check.radius[each.key].id
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

  alarm_rule = join(" AND ", formatlist("ALARM(\"%s\")", [for alarm in aws_cloudwatch_metric_alarm.radius_healthcheck : alarm.alarm_name]))
}

# TODO This resource can be removed after the switch to the NLBs
resource "aws_cloudwatch_metric_alarm" "radius_latency" {
  for_each = {
    for az, subnet
    in aws_subnet.wifi_frontend_subnet :
    index(data.aws_availability_zones.zones.names, az) => subnet.id
  }

  provider            = aws.us_east_1
  alarm_name          = "${aws_route53_health_check.radius[each.key].reference_name}-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "TimeToFirstByte"
  namespace           = "AWS/Route53"
  period              = "120"
  statistic           = "Average"
  threshold           = "1000"

  dimensions = {
    HealthCheckId = aws_route53_health_check.radius[each.key].id
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
