resource "aws_cloudwatch_log_group" "user-signup-api-log-group" {
  count = "${var.user-signup-enabled}"
  name  = "${var.Env-Name}-user-signup-api-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "user-signup-api-ecr" {
  count = "${var.ecr-repository-count}"
  name  = "govwifi/user-signup-api"
}

resource "aws_iam_role" "user-signup-api-task-role" {
  count = "${var.user-signup-enabled}"
  name  = "${var.Env-Name}-user-signup-api-task-role"

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
  count      = "${var.user-signup-enabled}"
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
    }, {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": ["${data.aws_s3_bucket.admin-bucket.arn}/signup-whitelist.conf"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::${var.metrics-bucket-name}/*"
    }
  ]
}
EOF
}

data "aws_s3_bucket" "admin-bucket" {
  count  = "${var.user-signup-enabled}"
  bucket = "${var.admin-bucket-name}"
}

resource "aws_ecs_task_definition" "user-signup-api-task" {
  count                    = "${var.user-signup-enabled}"
  family                   = "user-signup-api-task-${var.Env-Name}"
  task_role_arn            = "${aws_iam_role.user-signup-api-task-role.arn}"
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
      "name": "user-signup",
      "ulimits": null,
      "dockerSecurityOptions": null,
      "environment": [
        {
          "name": "DB_NAME",
          "value": "govwifi_${var.env}_users"
        },{
          "name": "DB_PASS",
          "value": "${var.user-db-password}"
        },{
          "name": "DB_USER",
          "value": "${var.user-db-username}"
        },{
          "name": "DB_HOSTNAME",
          "value": "${var.user-db-hostname}"
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
          "name": "NOTIFY_API_KEY",
          "value": "${var.notify-api-key}"
        },{
          "name": "PERFORMANCE_URL",
          "value": "${var.performance-url}"
        },{
          "name": "PERFORMANCE_DATASET",
          "value": "${var.performance-dataset}"
        },{
          "name": "PERFORMANCE_BEARER_VOLUMETRICS",
          "value": "${var.performance-bearer-volumetrics}"
        },{
          "name": "PERFORMANCE_BEARER_COMPLETION_RATE",
          "value": "${var.performance-bearer-completion-rate}"
        },{
          "name": "S3_SIGNUP_WHITELIST_BUCKET",
          "value": "${data.aws_s3_bucket.admin-bucket.bucket}"
        },{
          "name": "S3_SIGNUP_WHITELIST_OBJECT_KEY",
          "value": "signup-whitelist.conf"
        },{
          "name": "FIRETEXT_TOKEN",
          "value": "${var.firetext-token}"
        },{
          "name": "GOVNOTIFY_BEARER_TOKEN",
          "value": "${var.govnotify-bearer-token}"
        },
        {
          "name": "S3_METRICS_BUCKET",
          "value": "${var.metrics-bucket-name}"
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
  count           = "${var.user-signup-enabled}"
  name            = "user-signup-api-service-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.api-cluster.id}"
  task_definition = "${aws_ecs_task_definition.user-signup-api-task.arn}"
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
    target_group_arn = "${aws_alb_target_group.user-signup-api-tg.arn}"
    container_name   = "user-signup"
    container_port   = "8080"
  }
}

resource "aws_alb_target_group" "user-signup-api-tg" {
  count       = "${var.user-signup-enabled}"
  depends_on  = ["aws_lb.api-alb"]
  name        = "user-signup-api-${var.Env-Name}"
  port        = "8080"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc-id}"
  target_type = "ip"

  tags = {
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
