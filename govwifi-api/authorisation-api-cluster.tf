resource "aws_cloudwatch_log_group" "authorisation_api_log_group" {
  name = "${var.env_name}-authorisation-api-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "authorisation_api_ecr" {
  count = var.ecr_repository_count
  name  = "govwifi/authorisation-api"
}

resource "aws_ecs_task_definition" "authorisation_api_task" {
  family                   = "authorisation-api-task-${var.env_name}"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  memory                   = 512
  cpu                      = "256"
  network_mode             = "awsvpc"

  container_definitions = <<EOF
[
    {
      "volumesFrom": [],
      "memory": 512,
      "extraHosts": null,
      "dnsServers": null,
      "disableNetworking": null,
      "dnsSearchDomains": null,
      "portMappings": [
        {
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "hostname": null,
      "essential": true,
      "entryPoint": null,
      "mountPoints": [],
      "name": "authorisation",
      "ulimits": null,
      "dockerSecurityOptions": null,
      "environment": [
        {
          "name": "DB_NAME",
          "value": "govwifi_${var.env}_users"
        },{
          "name": "DB_HOSTNAME",
          "value": "${var.user_rr_hostname}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack_env}"
        },{
          "name": "SENTRY_CURRENT_ENV",
          "value": "${var.sentry_current_env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.authentication_sentry_dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.env_name}"
        }
      ],"secrets": [
        {
          "name": "DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:password::"
        },{
          "name": "DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:username::"
        }
      ],
      "links": null,
      "workingDirectory": null,
      "readonlyRootFilesystem": null,
      "image": "${var.auth_docker_image}",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.authorisation_api_log_group.name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.env_name}-authorisation-api-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF

}

resource "aws_ecs_service" "authorisation_api_service" {
  name             = "authorisation-api-service-${var.env_name}"
  cluster          = aws_ecs_cluster.api_cluster.id
  task_definition  = aws_ecs_task_definition.authorisation_api_task.arn
  desired_count    = var.authorisation_api_count
  launch_type      = "FARGATE"
  platform_version = "1.3.0"

  network_configuration {
    security_groups = concat(
      var.backend_sg_list,
      [aws_security_group.api_in.id],
      [aws_security_group.api_out.id],
    )

    subnets          = var.subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    container_name   = "authorisation"
    container_port   = "8080"
  }
}

resource "aws_alb_listener_rule" "static" {
  depends_on   = [aws_alb_target_group.alb_target_group]
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.id
  }

  condition {
    path_pattern {
      values = ["/authorize/*"]
    }
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  depends_on  = [aws_lb.api_alb]
  name        = "api-lb-tg-${var.env_name}"
  port        = "8080"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  tags = {
    Name = "api-alb-tg-${var.env_name}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 4
    interval            = 10
    path                = "/authorize/user/HEALTH"
  }
}
