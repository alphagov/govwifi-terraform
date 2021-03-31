resource "aws_cloudwatch_metric_alarm" "grafana" {
  provider            = "aws.route53-alarms"
#  alarm_name          = "${aws_route53_health_check.grafana-healthcheck.reference_name}-hc"
  alarm_name          = "${aws_route53_health_check.grafana-healthcheck.reference_name}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  treat_missing_data  = "breaching"

  dimensions = {
    HealthCheckId = "${aws_route53_health_check.grafana-healthcheck.id}"
  }

  alarm_actions = [
    "${var.route53-critical-notifications-arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "grafana-latency" {
  provider            = "aws.route53-alarms"
  alarm_name          = "${aws_route53_health_check.grafana-healthcheck.reference_name}-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "TimeToFirstByte"
  namespace           = "AWS/Route53"
  period              = "120"
  statistic           = "Average"
  threshold           = "1000"

  dimensions = {
    HealthCheckId = "${aws_route53_health_check.grafana-healthcheck.id}"
  }

  alarm_actions = [
    "${var.route53-critical-notifications-arn}",
  ]
}
