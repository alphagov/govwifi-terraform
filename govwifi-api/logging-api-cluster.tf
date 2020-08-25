resource "aws_cloudwatch_log_group" "logging-api-log-group" {
  count = "${var.logging-enabled}"
  name  = "${var.Env-Name}-logging-api-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "logging-api-ecr" {
  count = "${var.ecr-repository-count}"
  name  = "govwifi/logging-api"
}

resource "aws_ecs_task_definition" "logging-api-task" {
  count                    = "${var.logging-enabled}"
  family                   = "logging-api-task-${var.Env-Name}"
  task_role_arn            = "${aws_iam_role.logging-api-task-role.arn}"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
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
          "name": "DB_PASS",
          "value": "${var.db-password}"
        },{
          "name": "DB_USER",
          "value": "${var.db-user}"
        },{
          "name": "DB_HOSTNAME",
          "value": "${var.db-hostname}"
        },{
          "name": "USER_DB_NAME",
          "value": "govwifi_${var.env}_users"
        },{
          "name": "USER_DB_PASS",
          "value": "${var.user-db-password}"
        },{
          "name": "USER_DB_USER",
          "value": "${var.user-db-username}"
        },{
          "name": "USER_DB_HOSTNAME",
          "value": "${var.user-db-hostname}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.logging-sentry-dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
        },{
          "name": "PERFORMANCE_URL",
          "value": "${var.performance-url}"
        },{
          "name": "PERFORMANCE_DATASET",
          "value": "${var.performance-dataset}"
        },{
          "name": "PERFORMANCE_BEARER_ACTIVE_USERS",
          "value": "${var.performance-bearer-active-users}"
        },{
          "name": "PERFORMANCE_BEARER_UNIQUE_USERS",
          "value": "${var.performance-bearer-unique-users}"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_BUCKET",
          "value": "govwifi-${var.rack-env}-admin"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY",
          "value": "ips-and-locations.json"
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
          "awslogs-group": "${aws_cloudwatch_log_group.logging-api-log-group.name}",
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

resource "aws_ecs_service" "logging-api-service" {
  count           = "${var.logging-enabled}"
  name            = "logging-api-service-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.api-cluster.id}"
  task_definition = "${aws_ecs_task_definition.logging-api-task.arn}"
  desired_count   = "${var.backend-instance-count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [
      "${var.backend-sg-list}",
      "${aws_security_group.api-in.id}",
      "${aws_security_group.api-out.id}",
    ]

    subnets          = ["${var.subnet-ids}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.logging-api-tg.arn}"
    container_name   = "logging"
    container_port   = "8080"
  }
}

resource "aws_alb_target_group" "logging-api-tg" {
  count       = "${var.logging-enabled}"
  depends_on  = ["aws_lb.api-alb"]
  name        = "logging-api-${var.Env-Name}"
  port        = "8080"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc-id}"
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

resource "aws_alb_listener_rule" "logging-api-lr" {
  count        = "${var.logging-enabled}"
  depends_on   = ["aws_alb_target_group.logging-api-tg"]
  listener_arn = "${aws_alb_listener.alb_listener.arn}"
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.logging-api-tg.id}"
  }

  condition {
    field  = "path-pattern"
    values = ["/logging/*"]
  }
}

resource "aws_iam_role" "logging-api-task-role" {
  count = "${var.logging-enabled}"
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

resource "aws_iam_role_policy" "logging-api-task-policy" {
  count      = "${var.logging-enabled}"
  name       = "${var.Env-Name}-logging-api-task-policy"
  role       = "${aws_iam_role.logging-api-task-role.id}"
  depends_on = ["aws_iam_role.logging-api-task-role"]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::govwifi-${var.rack-env}-admin/*"
    }
  ]
}
EOF
}
