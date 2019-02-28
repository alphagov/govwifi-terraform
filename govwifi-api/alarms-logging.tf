resource "aws_cloudwatch_metric_alarm" "logging-ecs-cpu-alarm-high" {
  count               = "${var.alarm-count}"
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

  alarm_description = "This alarm tells ECS to scale up based on high CPU - Logging"

  alarm_actions = [
    "${aws_appautoscaling_policy.ecs-policy-up-logging.arn}",
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-ecs-cpu-alarm-low" {
  count               = "${var.alarm-count}"
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

  alarm_description = "This alarm tells ECS to scale in based on low CPU usage - Logging"

  alarm_actions = [
    "${aws_appautoscaling_policy.ecs-policy-down-logging.arn}",
  ]
}

/*
resource "aws_cloudwatch_metric_alarm" "radius-access-reject" {
  count               = "${var.alarm-count}"
  alarm_name          = "${var.Env-Name}-radius-access-reject"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  threshold           = "0.2"
  alarm_description   = "Access rejections has exceeded 20%"

  metric_query {
    id          = "e1"
    expression  = "rejected"
    label       = "Rejection rate"
    return_data = "true"
  }

  metric_query {
    id = "accepted"

    metric {
      metric_name = "${aws_cloudwatch_log_metric_filter.radius-access-accept.name}"
      namespace   = "${local.logging_api_namespace}"
      period      = "300"
      stat        = "Sum"
    }
  }

  metric_query {
    id = "rejected"

    metric {
      metric_name = "${aws_cloudwatch_log_metric_filter.radius-access-reject.name}"
      namespace   = "${local.logging_api_namespace}"
      period      = "300"
      stat        = "Sum"
    }
  }
}
*/

resource "aws_cloudwatch_metric_alarm" "radius-access-reject" {
  count               = "${var.alarm-count}"
  alarm_name          = "${var.Env-Name}-radius-access-reject"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "3"
  period              = "60"
  threshold           = "1000"
  alarm_description   = "Access rejections has exceeded 1000"
  metric_name         = "${aws_cloudwatch_log_metric_filter.radius-access-reject.metric_transformation.0.name}"
  namespace           = "${local.logging_api_namespace}"
  statistic           = "Sum"

  alarm_actions = [
    "${var.devops-notifications-arn}",
  ]
}
