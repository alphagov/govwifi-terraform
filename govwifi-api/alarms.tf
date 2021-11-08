resource "aws_cloudwatch_metric_alarm" "auth_ecs_cpu_alarm_high" {
  count               = var.alarm_count
  alarm_name          = "${var.env_name}-auth-ecs-cpu-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    ClusterName = aws_ecs_cluster.api_cluster.name
    ServiceName = aws_ecs_service.authorisation_api_service.name
  }

  alarm_description = "ECS cluster CPU is high, scaling up number of tasks. Investigate api cluster and CloudWatch logs for root cause."

  alarm_actions = [
    aws_appautoscaling_policy.ecs_policy_up.arn,
    var.devops_notifications_arn,
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth_ecs_cpu_alarm_low" {
  count               = var.alarm_count
  alarm_name          = "${var.env_name}-downscale-auth-ecs-cpu-low-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.low_cpu_threshold
  datapoints_to_alarm = "1"

  dimensions = {
    ClusterName = aws_ecs_cluster.api_cluster.name
    ServiceName = aws_ecs_service.authorisation_api_service.name
  }

  alarm_description = "ECS cluster CPU is low, scaling down number of ECS tasks to save on cost."

  alarm_actions = [
    aws_appautoscaling_policy.ecs_policy_down.arn,
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "authentication_api_no_healthy_hosts" {
  alarm_name          = "${var.env_name} authentication API no healthy hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  datapoints_to_alarm = "1"

  dimensions = {
    LoadBalancer = aws_lb.api_alb[0].arn_suffix
  }

  alarm_description = "Load balancer detects no healthy authentication API targets. Investigate api cluster and CloudWatch logs for root cause."

  alarm_actions = compact([
    var.notification_arn,
  ])
}

resource "aws_cloudwatch_metric_alarm" "user_signup_api_no_healthy_hosts" {
  count = var.user_signup_enabled

  alarm_name          = "${var.env_name} user signup API no healthy hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  datapoints_to_alarm = "1"

  dimensions = {
    LoadBalancer = aws_lb.user_signup_api[0].arn_suffix
  }

  alarm_description = "Load balancer detects no healthy user signup API targets. Investigate api ECS cluster and CloudWatch logs for root cause."

  alarm_actions = compact([
    var.notification_arn,
  ])
}
