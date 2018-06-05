resource "aws_autoscaling_policy" "scale-policy" {
  name                   = "${var.Env-Name}-api-scale-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.api-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm" {
  count               = "${var.backend-cpualarm-count}"
  alarm_name          = "${var.Env-Name}-api-cpu-alarm"
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
