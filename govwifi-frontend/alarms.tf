resource "aws_cloudwatch_metric_alarm" "radius_healthcheck" {
  provider = aws.route53-alarms
  count    = var.radius-instance-count
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

# TODO: This requires a more up to date version of the AWS provider to work
# We will also need to feature toggle the alarm actions so the notification ARN points to PagerDuty for production
# and an appropriate email group for staging. See implementation of `notification_arn` in govwifi/staging-london/main.tf
# and govwifi/wifi-london/main.tf

# https://trello.com/c/Jsis2ZR1/1042-5-upgrade-the-terraform-aws-provider-to-a-more-recent-version
#
# resource "aws_cloudwatch_composite_alarm" "all_radius_servers_down" {
#   provider = aws.route53-alarms
#   alarm_name = "${var.Env-Name} ${var.aws-region} All Radius servers down"

#   alarm_actions = [var.pagerduty_notification_arn]

#   alarm_rule = join(" AND ", formatlist("ALARM(\"%s\")", aws_cloudwatch_metric_alarm.radius-hc[*].alarm_name))
# }

resource "aws_cloudwatch_metric_alarm" "radius_latency" {
  provider = aws.route53-alarms
  count    = var.radius-instance-count
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
  alarm_name          = "${var.Env-Name}-radius-cannot-connect-to-api"
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
