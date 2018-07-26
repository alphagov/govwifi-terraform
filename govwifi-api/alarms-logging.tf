resource "aws_cloudwatch_metric_alarm" "logging-ecs-cpu-alarm-high" {
  alarm_name          = "${var.Env-Name}-logging-ecs-cpu-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"

  dimensions {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
    ServiceName = "${aws_ecs_service.logging-api-service.name}"
  }

  alarm_description  = "This alarm tells ECS to scale up based on high CPU - Logging"
  alarm_actions      = [
    "${aws_appautoscaling_policy.ecs-policy-up-logging.arn}",
    "${var.devops-notifications-arn}"
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-ecs-cpu-alarm-low" {
  alarm_name          = "${var.Env-Name}-logging-ecs-cpu-alarm-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
    ServiceName = "${aws_ecs_service.logging-api-service.name}"
  }

  alarm_description  = "This alarm tells ECS to scale in based on low CPU usage - Logging"
  alarm_actions      = [
    "${aws_appautoscaling_policy.ecs-policy-down-logging.arn}",
    "${var.devops-notifications-arn}"
  ]
}
