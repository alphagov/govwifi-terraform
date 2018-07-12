resource "aws_cloudwatch_log_group" "user-signup-api-log-group" {
  name = "${var.Env-Name}-user-signup-api-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "user-signup-api-ecr" {
  count = "${var.ecr-repository-count}"
  name  = "govwifi/user-signup-api"
}

resource "aws_iam_role" "user-signup-api-task-role" {
  name = "${var.Env-Name}-user-signup-api-task-role"

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

resource "aws_iam_role_policy" "user-signup-api-task-policy" {
  name       = "${var.Env-Name}-user-signup-api-task-policy"
  role       = "${aws_iam_role.user-signup-api-task-role.id}"
  depends_on = ["aws_iam_role.user-signup-api-task-role"]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::${var.Env-Name}-emailbucket/*"
    }
  ]
}
EOF
}

resource "aws_ecs_task_definition" "user-signup-api-task" {
  family = "user-signup-api-task-${var.Env-Name}"
  task_role_arn = "${aws_iam_role.user-signup-api-task-role.arn}"

  container_definitions = <<EOF
[
    {
      "volumesFrom": [],
      "memory": 1900,
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
      "name": "user-signup",
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
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.user-signup-sentry-dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
        },{
          "name": "AUTHORISED_EMAIL_DOMAINS_REGEX",
          "value": ${jsonencode(var.authorised-email-domains-regex)}
        },{
          "name": "NOTIFY_API_KEY",
          "value": "${var.notify-api-key}"
        }
      ],
      "links": null,
      "workingDirectory": null,
      "readonlyRootFilesystem": null,
      "image": "${var.user-signup-docker-image}",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.user-signup-api-log-group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-user-signup-api-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF
}

resource "aws_ecs_service" "user-signup-api-service" {
  name            = "user-signup-api-service-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.api-cluster.id}"
  task_definition = "${aws_ecs_task_definition.user-signup-api-task.arn}"
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
    target_group_arn = "${aws_alb_target_group.user-signup-api-tg.arn}"
    container_name   = "user-signup"
    container_port   = "8080"
  }
}

resource "aws_alb_target_group" "user-signup-api-tg" {
  depends_on   = ["aws_lb.api-alb"]
  name     = "user-signup-api-${var.Env-Name}"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = "${var.vpc-id}"

  tags {
    Name = "user-signup-api-tg-${var.Env-Name}"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/healthcheck"
  }
}

resource "aws_alb_listener_rule" "user-signup-api-lr" {
  depends_on   = ["aws_alb_target_group.user-signup-api-tg"]
  listener_arn = "${aws_alb_listener.alb_listener.arn}"
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.user-signup-api-tg.id}"
  }
  condition {
    field  = "path-pattern"
    values = ["/user-signup/*"]
  }
}
