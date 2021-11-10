resource "aws_cloudwatch_log_group" "user_signup_api_log_group" {
  count = var.user_signup_enabled
  name  = "${var.env_name}-user-signup-api-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "user_signup_api_ecr" {
  count = var.ecr_repository_count
  name  = "govwifi/user-signup-api"
}

resource "aws_iam_role" "user_signup_api_task_role" {
  count = var.user_signup_enabled
  name  = "${var.env_name}-user-signup-api-task-role"

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

resource "aws_iam_role_policy" "user_signup_api_task_policy" {
  count      = var.user_signup_enabled
  name       = "${var.env_name}-user-signup-api-task-policy"
  role       = aws_iam_role.user_signup_api_task_role[0].id
  depends_on = [aws_iam_role.user_signup_api_task_role]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::${var.env_name}-emailbucket/*"
    }, {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": ["${data.aws_s3_bucket.admin_bucket[0].arn}/signup-whitelist.conf"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::${var.metrics_bucket_name}/*"
    }
  ]
}
EOF

}

data "aws_s3_bucket" "admin_bucket" {
  count  = var.user_signup_enabled
  bucket = var.admin_app_data_s3_bucket_name
}

resource "aws_ecs_task_definition" "user_signup_api_task" {
  count                    = var.user_signup_enabled
  family                   = "user-signup-api-task-${var.env_name}"
  task_role_arn            = aws_iam_role.user_signup_api_task_role[0].arn
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
      "name": "user-signup",
      "ulimits": null,
      "dockerSecurityOptions": null,
      "environment": [
        {
          "name": "DB_NAME",
          "value": "govwifi_${var.env}_users"
        },{
          "name": "DB_HOSTNAME",
          "value": "${var.user_db_hostname}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack_env}"
        },{
          "name": "SENTRY_CURRENT_ENV",
          "value": "${var.sentry_current_env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.user_signup_sentry_dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.env_name}"
        },{
          "name": "S3_SIGNUP_WHITELIST_BUCKET",
          "value": "${data.aws_s3_bucket.admin_bucket[0].bucket}"
        },{
          "name": "S3_SIGNUP_WHITELIST_OBJECT_KEY",
          "value": "signup-whitelist.conf"
        },{
          "name": "FIRETEXT_TOKEN",
          "value": "${var.firetext_token}"
        }
      ],
      "secrets": [
        {
          "name": "DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:password::"
        },{
          "name": "DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:username::"
        },{
          "name": "NOTIFY_API_KEY",
          "valueFrom": "${data.aws_secretsmanager_secret_version.notify_api_key.arn}:notify-api-key::"
        },{
          "name": "GOVNOTIFY_BEARER_TOKEN",
          "valueFrom": "${data.aws_secretsmanager_secret_version.notify_bearer_token.arn}:token::"
        }
      ],
      "links": null,
      "workingDirectory": null,
      "readonlyRootFilesystem": null,
      "image": "${var.user_signup_docker_image}",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.user_signup_api_log_group[0].name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.env_name}-user-signup-api-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF

}

resource "aws_ecs_service" "user_signup_api_service" {
  count            = var.user_signup_enabled
  name             = "user-signup-api-service-${var.env_name}"
  cluster          = aws_ecs_cluster.api_cluster.id
  task_definition  = aws_ecs_task_definition.user_signup_api_task[0].arn
  desired_count    = var.backend_instance_count
  launch_type      = "FARGATE"
  platform_version = "1.3.0"

  network_configuration {
    security_groups = concat(
      var.backend_sg_list,
      [aws_security_group.api_in.id],
      [aws_security_group.api_out.id]
    )

    subnets          = var.subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.user_signup_api_tg[0].arn
    container_name   = "user-signup"
    container_port   = "8080"
  }
}

resource "aws_alb_target_group" "user_signup_api_tg" {
  count       = var.user_signup_enabled
  depends_on  = [aws_lb.api_alb]
  name        = "user-signup-api-${var.env_name}"
  port        = "8080"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  tags = {
    Name = "user-signup-api-tg-${var.env_name}"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/healthcheck"
  }
}
