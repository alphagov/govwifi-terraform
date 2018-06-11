resource "aws_autoscaling_policy" "api-ec2-scale-up-policy" {
  name                   = "${var.Env-Name}-api-ec2-scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.api-asg.name}"
}

resource "aws_autoscaling_policy" "api-ec2-scale-down-policy" {
  name                   = "${var.Env-Name}-api-ec2-scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.api-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "ec2-api-cpu-alarm-low" {
  alarm_name          = "${var.Env-Name}-ec2-api-cpu-alarm-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.api-asg.name}"
  }

  alarm_description  = "This alarm tells EC2 to scale in"
  alarm_actions      = ["${aws_autoscaling_policy.api-ec2-scale-down-policy.arn}", "${var.critical-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "ec2-api-cpu-alarm-high" {
  alarm_name          = "${var.Env-Name}-ec2-api-cpu-alarm-high"
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

  alarm_description  = "This alarm tells EC2 to scale up"
  alarm_actions      = ["${aws_autoscaling_policy.api-ec2-scale-up-policy.arn}", "${var.critical-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth-ecs-cpu-alarm-high" {
  alarm_name          = "${var.Env-Name}-auth-ecs-cpu-alarm-high"
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

  alarm_description  = "This alarm tells ECS to scale up"
  alarm_actions      = ["${aws_appautoscaling_policy.ecs-policy-up.arn}", "${var.critical-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth-ecs-cpu-alarm-low" {
  alarm_name          = "${var.Env-Name}-auth-ecs-cpu-alarm-low"
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

  alarm_description  = "This alarm tells ECS to scale in"
  alarm_actions      = ["${aws_appautoscaling_policy.ecs-policy-down.arn}", "${var.critical-notifications-arn}"]
  treat_missing_data = "breaching"
}

resource "aws_appautoscaling_target" "auth-ecs-target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.api-cluster.name}/${aws_ecs_service.authorisation-api-service.name}"
  max_capacity       = 10
  min_capacity       = 2
  role_arn           = "${var.ecs-service-role}"
  scalable_dimension = "ecs:service:DesiredCount"
}

resource "aws_appautoscaling_policy" "ecs-policy-up" {
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

  depends_on = ["aws_appautoscaling_target.auth-ecs-target"]
}

resource "aws_appautoscaling_policy" "ecs-policy-down" {
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

  depends_on = ["aws_appautoscaling_target.auth-ecs-target"]
}
