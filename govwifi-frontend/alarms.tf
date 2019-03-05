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

  dimensions {
    HealthCheckId = "${element(aws_route53_health_check.radius.*.id, count.index)}"
  }
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
}
