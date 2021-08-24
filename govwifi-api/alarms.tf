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

  alarm_description = "ECS Cluster CPU is high, scaling up number of ECS tasks"

  alarm_actions = [
    aws_appautoscaling_policy.ecs-policy-up.arn,
    var.devops-notifications-arn,
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth-ecs-cpu-alarm-low" {
  count               = var.alarm-count
  alarm_name          = "${var.Env-Name}-downscale-auth-ecs-cpu-low-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.low_cpu_threshold
  datapoints_to_alarm = "1"

  dimensions = {
    ClusterName = aws_ecs_cluster.api-cluster.name
    ServiceName = aws_ecs_service.authorisation-api-service.name
  }

  alarm_description = "ECS Cluster CPU is low, scaling down number of ECS tasks"

  alarm_actions = [
    aws_appautoscaling_policy.ecs-policy-down.arn,
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "authentication-api-no-healthy-hosts" {
  alarm_name          = "${var.Env-Name} authentication API no healthy hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  datapoints_to_alarm = "1"

  dimensions = {
    LoadBalancer = aws_lb.api-alb[0].arn_suffix
  }

  alarm_description = "Load balancer detects no healthy API targets"

  alarm_actions = compact([
    var.notification_arn,
  ])
}

resource "aws_cloudwatch_metric_alarm" "user-signup-api-no-healthy-hosts" {
  count = var.user-signup-enabled

  alarm_name          = "${var.Env-Name} user signup API no healthy hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  datapoints_to_alarm = "1"

  dimensions = {
    LoadBalancer = aws_lb.user-signup-api[0].arn_suffix
  }

  alarm_description = "Load balancer detects no healthy user signup API targets"

  alarm_actions = compact([
    var.notification_arn,
  ])
}
