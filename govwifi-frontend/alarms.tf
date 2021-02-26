resource "aws_cloudwatch_metric_alarm" "radius-hc" {
  provider            = "aws.route53-alarms"
  count               = "${aws_route53_health_check.radius.count}"
  alarm_name          = "${element(aws_route53_health_check.radius.*.reference_name, count.index)}-hc"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  treat_missing_data  = "breaching"

  dimensions = {
    HealthCheckId = "${element(aws_route53_health_check.radius.*.id, count.index)}"
  }

  alarm_actions = [
    "${var.route53-critical-notifications-arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "radius-latency" {
  provider            = "aws.route53-alarms"
  count               = "${aws_route53_health_check.radius.count}"
  alarm_name          = "${element(aws_route53_health_check.radius.*.reference_name, count.index)}-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "TimeToFirstByte"
  namespace           = "AWS/Route53"
  period              = "120"
  statistic           = "Average"
  threshold           = "1000"

  dimensions = {
    HealthCheckId = "${element(aws_route53_health_check.radius.*.id, count.index)}"
  }

  alarm_actions = [
    "${var.route53-critical-notifications-arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "radius-cannot-connect-to-api" {
  alarm_name          = "${var.Env-Name}-radius-cannot-connect-to-api"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 2
  period              = "60"
  statistic           = "Sum"
  treat_missing_data  = "breaching"
  metric_name         = "${aws_cloudwatch_log_metric_filter.radius-cannot-connect-to-api.metric_transformation.0.name}"
  namespace           = "${aws_cloudwatch_log_metric_filter.radius-cannot-connect-to-api.metric_transformation.0.namespace}"

  alarm_actions = [
    "${var.devops-notifications-arn}",
  ]
}
