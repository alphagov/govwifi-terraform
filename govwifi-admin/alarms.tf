resource "aws_cloudwatch_metric_alarm" "admin_no_healthy_hosts" {
  alarm_name          = "${var.env_name} admin no healthy hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  datapoints_to_alarm = "1"

  dimensions = {
    LoadBalancer = aws_lb.admin_alb.arn_suffix
  }

  alarm_description = "Load balancer detects no healthy admin targets. Investigate admin-api ECS cluster and CloudWatch logs for root cause."

  alarm_actions = compact([
    var.notification_arn,
  ])
}

resource "aws_cloudwatch_metric_alarm" "admin_node_unhealthy" {
  alarm_name          = "GovWifi - Production - admin-alb-wifi Node Unhealthy"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Minimum"
  threshold           = "0.0"
  alarm_description   = "Failure of any ALB Node in \"admin-alb-wifi\" consistently for a 5 minute period\n\nCheck the end points of the ALB to see if there is an issue"

  alarm_actions = [var.capacity_notifications_arn]

  dimensions = {
    TargetGroup  = aws_alb_target_group.admin_tg.arn_suffix
    LoadBalancer = aws_lb.admin_alb.arn_suffix
  }
}
