resource "aws_cloudwatch_log_group" "authorisation-api-log-group" {
  name = "${var.Env-Name}-authorisation-api-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecs_task_definition" "authorisation-api-task" {
  family = "authorisation-api-task-${var.Env-Name}"

  container_definitions = <<EOF
[
    {
      "volumesFrom": [],
      "memory": 950,
      "extraHosts": null,
      "dnsServers": null,
      "disableNetworking": null,
      "dnsSearchDomains": null,
      "portMappings": [
        {
          "hostPort": 0,
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
          "value": "govwifi_${var.Env-Name}"
        },{
          "name": "DB_PASS",
          "value": "${var.db-password}"
        },{
          "name": "DB_USER",
          "value": "${var.db-user}"
        },{
          "name": "DB_HOSTNAME",
          "value": "${var.db-read-replica-hostname}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.authentication-sentry-dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
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
          "awslogs-group": "${aws_cloudwatch_log_group.authorisation-api-log-group.name}",
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

resource "aws_ecs_service" "authorisation-api-service" {
  name            = "authorisation-api-service-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.api-cluster.id}"
  task_definition = "${aws_ecs_task_definition.authorisation-api-task.arn}"
  desired_count   = "${var.backend-instance-count}"
  iam_role        = "${var.ecs-service-role}"

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.authorisation-api-tg.arn}"
    container_name   = "authorisation"
    container_port   = "8080"
  }
}

resource "aws_alb_target_group" "authorisation-api-tg" {
  depends_on = ["aws_lb.api-alb"]
  name       = "authorisation-api-${var.Env-Name}"
  port       = "8080"
  protocol   = "HTTP"
  vpc_id     = "${var.vpc-id}"

  tags {
    Name = "authorisation-api-tg-${var.Env-Name}"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/authorize/user/HEALTH"
  }
}

resource "aws_alb_listener_rule" "authorisation-api-lr" {
  depends_on   = ["aws_alb_target_group.authorisation-api-tg"]
  listener_arn = "${aws_alb_listener.alb_listener.arn}"
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.authorisation-api-tg.id}"
  }

  condition {
    field  = "path-pattern"
    values = ["/authorize/*"]
  }
}
