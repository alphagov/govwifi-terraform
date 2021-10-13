resource "aws_cloudwatch_log_group" "authorisation_api_log_group" {
  name = "${var.Env-Name}-authorisation-api-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "authorisation_api_ecr" {
  count = var.ecr-repository-count
  name  = "govwifi/authorisation-api"
}

resource "aws_ecs_task_definition" "authorisation_api_task" {
  family                   = "authorisation-api-task-${var.Env-Name}"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
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
          "value": "${var.user-rr-hostname}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SENTRY_CURRENT_ENV",
          "value": "${var.sentry-current-env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.authentication_sentry_dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
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
      "image": "${var.auth-docker-image}",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.authorisation_api_log_group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-authorisation-api-docker-logs"
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
  name             = "authorisation-api-service-${var.Env-Name}"
  cluster          = aws_ecs_cluster.api_cluster.id
  task_definition  = aws_ecs_task_definition.authorisation_api_task.arn
  desired_count    = var.authorisation-api-count
  launch_type      = "FARGATE"
  platform_version = "1.3.0"

  network_configuration {
    security_groups = concat(
      var.backend-sg-list,
      [aws_security_group.api_in.id],
      [aws_security_group.api_out.id],
    )

    subnets          = var.subnet-ids
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
    field  = "path-pattern"
    values = ["/authorize/*"]
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  depends_on  = [aws_lb.api_alb]
  name        = "api-lb-tg-${var.Env-Name}"
  port        = "8080"
  protocol    = "HTTP"
  vpc_id      = var.vpc-id
  target_type = "ip"

  tags = {
    Name = "api-alb-tg-${var.Env-Name}"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/authorize/user/HEALTH"
  }
}
