resource "aws_cloudwatch_metric_alarm" "logging-ecs-cpu-alarm-high" {
  count               = var.alarm-count
  alarm_name          = "${var.Env-Name}-logging-ecs-cpu-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    ClusterName = aws_ecs_cluster.api-cluster.name
    ServiceName = aws_ecs_service.logging-api-service[0].name
  }

  alarm_description = "This alarm tells ECS to scale up based on high CPU - Logging"

  alarm_actions = [
    aws_appautoscaling_policy.ecs-policy-up-logging[0].arn,
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-ecs-cpu-alarm-low" {
  count               = var.alarm-count
  alarm_name          = "${var.Env-Name}-downscale-logging-ecs-cpu-low-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "0.3"
  datapoints_to_alarm = "2"

  dimensions = {
    ClusterName = aws_ecs_cluster.api-cluster.name
    ServiceName = aws_ecs_service.logging-api-service[0].name
  }

  alarm_description = "Alarm scales down the number of ECS tasks in the cluster when CPU usage is low"

  alarm_actions = [
    aws_appautoscaling_policy.ecs-policy-down-logging[0].arn,
  ]
}

#resource "aws_cloudwatch_metric_alarm" "radius-access-reject" {
#  count               = "${var.alarm-count}"
#  alarm_name          = "${var.Env-Name}-radius-access-reject"
#  comparison_operator = "GreaterThanThreshold"
#  evaluation_periods  = "3"
#  period              = "60"
#  threshold           = "1000"
#  alarm_description   = "Access rejections has exceeded 1000"
#  metric_name         = "${aws_cloudwatch_log_metric_filter.radius-access-reject.metric_transformation.0.name}"
#  namespace           = "${local.logging_api_namespace}"
#  statistic           = "Sum"
#
#  alarm_actions = [
#    "${var.devops-notifications-arn}",
#  ]
#}
