resource "aws_cloudwatch_log_group" "logging_api_log_group" {
  count = var.logging-enabled
  name  = "${var.Env-Name}-logging-api-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "logging_api_ecr" {
  count = var.ecr-repository-count
  name  = "govwifi/logging-api"
}

resource "aws_ecs_task_definition" "logging_api_task" {
  count                    = var.logging-enabled
  family                   = "logging-api-task-${var.Env-Name}"
  task_role_arn            = aws_iam_role.logging_api_task_role[0].arn
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
      "name": "logging",
      "ulimits": null,
      "dockerSecurityOptions": null,
      "environment": [
        {
          "name": "DB_NAME",
          "value": "govwifi_${var.Env-Name}"
        },{
          "name": "DB_HOSTNAME",
          "value": "${var.db-hostname}"
        },{
          "name": "USER_DB_NAME",
          "value": "govwifi_${var.env}_users"
        },{
          "name": "USER_DB_HOSTNAME",
          "value": "${var.user-db-hostname}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SENTRY_CURRENT_ENV",
          "value": "${var.sentry-current-env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.logging_sentry_dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_BUCKET",
          "value": "${var.admin-bucket-name}"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY",
          "value": "ips-and-locations.json"
        }
      ],
      "secrets": [
        {
          "name": "DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:password::"
        },{
          "name": "DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:username::"
        },{
          "name": "USER_DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:password::"
        },{
          "name": "USER_DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:username::"
        },{
          "name": "VOLUMETRICS_ENDPOINT",
          "valueFrom": "${data.aws_secretsmanager_secret_version.volumetrics_elasticsearch_endpoint.arn}:endpoint::"
        }
      ],
      "links": null,
      "workingDirectory": null,
      "readonlyRootFilesystem": null,
      "image": "${var.logging-docker-image}",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.logging_api_log_group[0].name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-logging-api-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF

}

resource "aws_ecs_service" "logging_api_service" {
  count            = var.logging-enabled
  name             = "logging-api-service-${var.Env-Name}"
  cluster          = aws_ecs_cluster.api_cluster.id
  task_definition  = aws_ecs_task_definition.logging_api_task[0].arn
  desired_count    = var.backend-instance-count
  launch_type      = "FARGATE"
  platform_version = "1.3.0"

  network_configuration {
    security_groups = concat(
      var.backend-sg-list,
      [aws_security_group.api_in.id],
      [aws_security_group.api_out.id]
    )

    subnets          = var.subnet-ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.logging_api_tg[0].arn
    container_name   = "logging"
    container_port   = "8080"
  }
}

resource "aws_alb_target_group" "logging_api_tg" {
  count       = var.logging-enabled
  depends_on  = [aws_lb.api_alb]
  name        = "logging-api-${var.Env-Name}"
  port        = "8080"
  protocol    = "HTTP"
  vpc_id      = var.vpc-id
  target_type = "ip"

  tags = {
    Name = "logging-api-tg-${var.Env-Name}"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/healthcheck"
  }
}

resource "aws_alb_listener_rule" "logging_api_lr" {
  count        = var.logging-enabled
  depends_on   = [aws_alb_target_group.logging_api_tg]
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.logging_api_tg[0].id
  }

  condition {
    field  = "path-pattern"
    values = ["/logging/*"]
  }
}

resource "aws_iam_role" "logging_api_task_role" {
  count = var.logging-enabled
  name  = "${var.Env-Name}-logging-api-task-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "logging_api_task_policy" {
  count      = var.logging-enabled
  name       = "${var.Env-Name}-logging-api-task-policy"
  role       = aws_iam_role.logging_api_task_role[0].id
  depends_on = [aws_iam_role.logging_api_task_role]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::${var.admin-bucket-name}/*"
    },
    {
      "Effect": "Allow",
      "Action":[
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.metrics-bucket-name}",
        "arn:aws:s3:::${var.metrics-bucket-name}/*"
      ]
    }
  ]
}
EOF

}
