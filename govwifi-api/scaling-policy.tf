resource "aws_appautoscaling_target" "auth-ecs-target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.api-cluster.name}/${aws_ecs_service.authorisation-api-service.name}"
  max_capacity       = 20
  min_capacity       = 2
  scalable_dimension = "ecs:service:DesiredCount"
}

resource "aws_appautoscaling_policy" "ecs-policy-up" {
  name               = "ECS Scale Up"
  service_namespace  = "ecs"
  policy_type        = "StepScaling"
  resource_id        = "service/${aws_ecs_cluster.api-cluster.name}/${aws_ecs_service.authorisation-api-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
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
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.auth-ecs-target"]
}
