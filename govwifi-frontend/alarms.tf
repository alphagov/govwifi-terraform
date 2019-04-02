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

  dimensions {
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
  period              = "60"
  statistic           = "Average"
  threshold           = "1000"

  dimensions {
    HealthCheckId = "${element(aws_route53_health_check.radius.*.id, count.index)}"
  }

  alarm_actions = [
    "${var.route53-critical-notifications-arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "auth-shared-secret-incorrect" {
  alarm_name          = "${var.Env-Name}-shared-secret-incorrect"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1
  period              = "${60 * 60 * 24}"
  statistic           = "Sum"
  treat_missing_data  = "breaching"
  metric_name         = "${aws_cloudwatch_log_metric_filter.auth-shared-secret-incorrect.metric_transformation.0.name}"
  namespace           = "${aws_cloudwatch_log_metric_filter.auth-shared-secret-incorrect.metric_transformation.0.namespace}"

  alarm_actions = [
    "${var.devops-notifications-arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "outer-and-inner-identities-same" {
  alarm_name          = "${var.Env-Name}-outer-and-inner-identities-same"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1
  period              = "${60 * 60 * 24}"
  statistic           = "Sum"
  treat_missing_data  = "breaching"
  metric_name         = "${aws_cloudwatch_log_metric_filter.outer-and-inner-identities-same.metric_transformation.0.name}"
  namespace           = "${aws_cloudwatch_log_metric_filter.outer-and-inner-identities-same.metric_transformation.0.namespace}"

  alarm_actions = [
    "${var.devops-notifications-arn}",
  ]
}
