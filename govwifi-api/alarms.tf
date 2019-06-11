resource "aws_cloudwatch_metric_alarm" "ec2-api-cpu-alarm-low" {
  count               = "${var.alarm-count}"
  alarm_name          = "${var.Env-Name}-ec2-api-cpu-alarm-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.api-asg.name}"
  }

  alarm_description = "This alarm tells EC2 to scale in based on low CPU usage"

  alarm_actions = [
    "${aws_autoscaling_policy.api-ec2-scale-down-policy.arn}",
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "ec2-api-cpu-alarm-high" {
  count               = "${var.alarm-count}"
  alarm_name          = "${var.Env-Name}-ec2-api-cpu-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.api-asg.name}"
  }

  alarm_description = "This alarm tells EC2 to scale up based on high CPU usage"

  alarm_actions = [
    "${aws_autoscaling_policy.api-ec2-scale-up-policy.arn}",
    "${var.devops-notifications-arn}",
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth-ecs-cpu-alarm-high" {
  count               = "${var.alarm-count}"
  alarm_name          = "${var.Env-Name}-auth-ecs-cpu-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
    ServiceName = "${aws_ecs_service.authorisation-api-service.name}"
  }

  alarm_description = "This alarm tells ECS to scale up based on high CPU"

  alarm_actions = [
    "${aws_appautoscaling_policy.ecs-policy-up.arn}",
    "${var.devops-notifications-arn}",
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth-ecs-cpu-alarm-low" {
  count               = "${var.alarm-count}"
  alarm_name          = "${var.Env-Name}-auth-ecs-cpu-alarm-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
    ServiceName = "${aws_ecs_service.authorisation-api-service.name}"
  }

  alarm_description = "This alarm tells ECS to scale in based on low CPU usage"

  alarm_actions = [
    "${aws_appautoscaling_policy.ecs-policy-down.arn}",
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "ecs-api-memory-reservation-high" {
  count               = "${var.background-jobs-enabled}"
  alarm_name          = "${var.Env-Name}-ecs-api-memory-reservation-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
  }

  alarm_description = "Cluster memory reservation above 75%"

  alarm_actions = [
    "${aws_autoscaling_policy.api-ec2-scale-up-policy.arn}",
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "ecs-api-memory-reservation-low" {
  count               = "${var.background-jobs-enabled}"
  alarm_name          = "${var.Env-Name}-ecs-api-memory-reservation-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
  }

  alarm_description = "Cluster memory reservation below 40%"

  alarm_actions = [
    "${aws_autoscaling_policy.api-ec2-scale-down-policy.arn}",
  ]
}
