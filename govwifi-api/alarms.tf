resource "aws_cloudwatch_metric_alarm" "ec2-api-cpu-alarm-low" {
  alarm_name          = "${var.Env-Name}-ec2-api-cpu-alarm-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.api-asg.name}"
  }

  alarm_description  = "This alarm tells EC2 to scale in based on low CPU usage"
  alarm_actions      = [
    "${aws_autoscaling_policy.api-ec2-scale-down-policy.arn}"
    /* "${var.critical-notifications-arn}" */
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "ec2-api-cpu-alarm-high" {
  alarm_name          = "${var.Env-Name}-ec2-api-cpu-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "60"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.api-asg.name}"
  }

  alarm_description  = "This alarm tells EC2 to scale up based on high CPU usage"
  alarm_actions      = [
    "${aws_autoscaling_policy.api-ec2-scale-up-policy.arn}"
    /* "${var.critical-notifications-arn}" */
  ]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth-ecs-cpu-alarm-high" {
  alarm_name          = "${var.Env-Name}-auth-ecs-cpu-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"

  dimensions {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
    ServiceName = "${aws_ecs_service.authorisation-api-service.name}"
  }

  alarm_description  = "This alarm tells ECS to scale up based on high CPU"
  alarm_actions      = [
    "${aws_appautoscaling_policy.ecs-policy-up.arn}"
    /* "${var.critical-notifications-arn}" */
  ]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "auth-ecs-cpu-alarm-low" {
  alarm_name          = "${var.Env-Name}-auth-ecs-cpu-alarm-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "10"

  dimensions {
    ClusterName = "${aws_ecs_cluster.api-cluster.name}"
    ServiceName = "${aws_ecs_service.authorisation-api-service.name}"
  }

  alarm_description  = "This alarm tells ECS to scale in based on low CPU usage"
  alarm_actions      = [
    "${aws_appautoscaling_policy.ecs-policy-down.arn}"
    /* "${var.critical-notifications-arn}" */
  ]
}

resource "aws_cloudwatch_metric_alarm" "ec2-api-memory-alarm-high" {
  alarm_name          = "${var.Env-Name}-ec2-api-memory-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.api-asg.name}"
  }

  alarm_description  = "This alarm tells EC2 to scale up based on high memory usage"
  alarm_actions      = [
    "${aws_autoscaling_policy.api-ec2-scale-up-policy.arn}"
    /* "${var.critical-notifications-arn}" */
  ]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "ec2-api-memory-alarm-low" {
  alarm_name          = "${var.Env-Name}-ec2-api-memory-alarm-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "30"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.api-asg.name}"
  }

  alarm_description  = "This alarm tells EC2 to scale in based on low memory usage"
  alarm_actions      = [
    "${aws_autoscaling_policy.api-ec2-scale-down-policy.arn}"
    /* "${var.critical-notifications-arn}" */
  ]
  treat_missing_data = "notBreaching"
}
