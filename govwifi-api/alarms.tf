resource "aws_cloudwatch_metric_alarm" "auth-ecs-cpu-alarm-high" {
  count               = var.alarm-count
  alarm_name          = "${var.Env-Name}-auth-ecs-cpu-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    ClusterName = aws_ecs_cluster.api-cluster.name
    ServiceName = aws_ecs_service.authorisation-api-service.name
  }

  alarm_description = "This alarm tells ECS to scale up based on high CPU"

  alarm_actions = [
    aws_appautoscaling_policy.ecs-policy-up.arn,
    var.devops-notifications-arn,
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth-ecs-cpu-alarm-low" {
  count               = var.alarm-count
  alarm_name          = "${var.Env-Name}-auth-ecs-cpu-alarm-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  datapoints_to_alarm = "1"

  dimensions = {
    ClusterName = aws_ecs_cluster.api-cluster.name
    ServiceName = aws_ecs_service.authorisation-api-service.name
  }

  alarm_description = "This alarm tells ECS to scale in based on low CPU usage"

  alarm_actions = [
    aws_appautoscaling_policy.ecs-policy-down.arn,
  ]

  treat_missing_data = "breaching"
}

