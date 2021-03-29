resource "aws_appautoscaling_target" "logging-ecs-target" {
  count              = "${var.logging-enabled}"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.api-cluster.name}/${aws_ecs_service.logging-api-service.name}"
  max_capacity       = 20
  min_capacity       = 3
  scalable_dimension = "ecs:service:DesiredCount"
}

resource "aws_appautoscaling_policy" "ecs-policy-up-logging" {
  count              = "${var.logging-enabled}"
  name               = "ECS Scale Up Logging"
  service_namespace  = "${aws_appautoscaling_target.logging-ecs-target.service_namespace}"
  policy_type        = "StepScaling"
  resource_id        = "${aws_appautoscaling_target.logging-ecs-target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.logging-ecs-target.scalable_dimension}"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = ["aws_appautoscaling_target.logging-ecs-target"]
}

resource "aws_appautoscaling_policy" "ecs-policy-down-logging" {
  count              = "${var.logging-enabled}"
  name               = "ECS Scale Down"
  service_namespace  = "${aws_appautoscaling_target.logging-ecs-target.service_namespace}"
  resource_id        = "${aws_appautoscaling_target.logging-ecs-target.resource_id}"
  policy_type        = "StepScaling"
  scalable_dimension = "${aws_appautoscaling_target.logging-ecs-target.scalable_dimension}"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.logging-ecs-target"]
}
