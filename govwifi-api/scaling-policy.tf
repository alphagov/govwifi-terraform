resource "aws_autoscaling_policy" "scale-policy" {
  name                   = "${var.Env-Name}-api-scale-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.api-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm" {
  count               = "${var.backend-cpualarm-count}"
  alarm_name          = "${var.Env-Name}-api-cpu-alarm-ec2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.api-asg.name}"
  }

  alarm_description  = "This metric monitors ec2 cpu utilization"
  alarm_actions      = ["${aws_autoscaling_policy.scale-policy.arn}", "${var.critical-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth_service_high" {
  alarm_name          = "${var.Env-Name}-api-cpu-alarm-high-ecs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"

  dimensions {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
    ServiceName = "${aws_ecs_service.authorisation-api-service.name}"
  }

  alarm_description  = "This metric monitors ecs cpu utilization"
  alarm_actions      = ["${aws_appautoscaling_policy.ecs_policy_up.arn}", "${var.critical-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth_service_low" {
  alarm_name          = "${var.Env-Name}-api-cpu-alarm-low-ecs"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"

  dimensions {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
    ServiceName = "${aws_ecs_service.authorisation-api-service.name}"
  }

  alarm_description  = "Low CPU API ECS"
  alarm_actions      = ["${aws_appautoscaling_policy.ecs_policy_down.arn}", "${var.critical-notifications-arn}"]
  treat_missing_data = "breaching"
}
resource "aws_appautoscaling_target" "auth_ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.api-cluster.name}/${aws_ecs_service.authorisation-api-service.name}"
  max_capacity       = 6
  min_capacity       = 2
  role_arn           = "${var.ecs-service-role}"
  scalable_dimension = "ecs:service:DesiredCount"
}

resource "aws_appautoscaling_policy" "ecs_policy_up" {
  name               = "ECS Scale Up"
  service_namespace  = "ecs"
  policy_type        = "StepScaling"
  resource_id        = "service/${aws_ecs_cluster.api-cluster.name}/${aws_ecs_service.authorisation-api-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type    = "ChangeInCapacity"
    metric_aggregation_type   = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = 1
    }
  }

  depends_on = ["aws_appautoscaling_target.auth_ecs_target"]
}

resource "aws_appautoscaling_policy" "ecs_policy_down" {
  name               = "ECS Scale Down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.api-cluster.name}/${aws_ecs_service.authorisation-api-service.name}"
  policy_type        = "StepScaling"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type    = "ChangeInCapacity"
    metric_aggregation_type   = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.auth_ecs_target"]
}
