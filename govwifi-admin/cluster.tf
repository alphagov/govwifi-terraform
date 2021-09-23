resource "aws_ecs_cluster" "admin_cluster" {
  name = "${var.Env-Name}-admin-cluster"
}

resource "aws_cloudwatch_log_group" "admin_log_group" {
  name = "${var.Env-Name}-admin-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "govwifi_admin_ecr" {
  count = var.ecr-repository-count
  name  = "govwifi/admin"
}

resource "aws_ecs_task_definition" "admin_task" {
  family                   = "admin-task-${var.Env-Name}"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_admin_instance_role.arn
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"

  container_definitions = <<EOF
[
    {
      "portMappings": [
        {
          "hostPort": 3000,
          "containerPort": 3000,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "name": "admin",
      "environment": [
        {
          "name": "DB_NAME",
          "value": "govwifi_admin_${var.rack-env}"
        },{
          "name": "DB_HOST",
          "value": "${aws_db_instance.admin_db.address}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SENTRY_CURRENT_ENV",
          "value": "${var.sentry-current-env}"
        },{
          "name": "RAILS_LOG_TO_STDOUT",
          "value": "1"
        },{
          "name": "RAILS_SERVE_STATIC_FILES",
          "value": "1"
        },{
          "name": "LONDON_RADIUS_IPS",
          "value": "${join(",", var.london-radius-ip-addresses)}"
        },{
          "name": "DUBLIN_RADIUS_IPS",
          "value": "${join(",", var.dublin-radius-ip-addresses)}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.sentry-dsn}"
        },{
          "name": "S3_MOU_BUCKET",
          "value": "${aws_s3_bucket.admin_mou_bucket[0].id}"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_BUCKET",
          "value": "${aws_s3_bucket.admin_bucket[0].id}"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY",
          "value": "ips-and-locations.json"
        },{
          "name": "S3_SIGNUP_WHITELIST_BUCKET",
          "value": "${aws_s3_bucket.admin_bucket[0].id}"
        },{
          "name": "S3_SIGNUP_WHITELIST_OBJECT_KEY",
          "value": "signup-whitelist.conf"
        },{
          "name": "S3_WHITELIST_OBJECT_KEY",
          "value": "clients.conf"
        },{
          "name": "S3_PRODUCT_PAGE_DATA_BUCKET",
          "value": "${aws_s3_bucket.product_page_data_bucket[0].id}"
        },{
          "name": "S3_ORGANISATION_NAMES_OBJECT_KEY",
          "value": "organisations.yml"
        },{
          "name": "S3_EMAIL_DOMAINS_OBJECT_KEY",
          "value": "domains.yml"
        },{
          "name": "LOGGING_API_SEARCH_ENDPOINT",
          "value": "${var.logging-api-search-url}"
        },{
          "name": "RR_DB_HOST",
          "value": "${var.rr-db-host}"
        },{
          "name": "RR_DB_NAME",
          "value": "${var.rr-db-name}"
        },{
          "name": "USER_DB_HOST",
          "value": "${var.user-db-host}"
        },{
          "name": "USER_DB_NAME",
          "value": "${var.user-db-name}"
        },{
          "name": "ZENDESK_API_ENDPOINT",
          "value": "${var.zendesk-api-endpoint}"
        },{
          "name": "ZENDESK_API_USER",
          "value": "${var.zendesk-api-user}"
        },{
          "name": "GOOGLE_MAPS_PUBLIC_API_KEY",
          "value": "${var.public-google-api-key}"
        }
      ],
      "secrets": [
        {
          "name": "DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.admin_db.arn}:password::"
        },{
          "name": "DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.admin_db.arn}:username::"
        },{
          "name": "DEVISE_SECRET_KEY",
          "valueFrom": "${data.aws_secretsmanager_secret_version.key_base.arn}:secret-key-base::"
        },{
          "name": "GOOGLE_SERVICE_ACCOUNT_BACKUP_CREDENTIALS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.google_service_account_backup_credentials.arn}:credentials::"
        },{
          "name": "NOTIFY_API_KEY",
          "valueFrom": "${data.aws_secretsmanager_secret_version.notify_api_key.arn}:notify-api-key::"
        },{
          "name": "OTP_SECRET_ENCRYPTION_KEY",
          "valueFrom": "${data.aws_secretsmanager_secret_version.otp_encryption_key.arn}:key::"
        },{
          "name": "RR_DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:password::"
        },{
          "name": "RR_DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:username::"
        },{
          "name": "SECRET_KEY_BASE",
          "valueFrom": "${data.aws_secretsmanager_secret_version.key_base.arn}:secret-key-base::"
        },{
          "name": "USER_DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:password::"
        },{
          "name": "USER_DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:username::"
        },{
          "name": "ZENDESK_API_TOKEN",
          "valueFrom": "${data.aws_secretsmanager_secret_version.zendesk_api_token.arn}:zendesk-api-token::"
        }
      ],
      "image": "${var.admin-docker-image}",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.admin_log_group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-admin-docker-logs"
        }
      },
      "expanded": true
    }
]
EOF

}

resource "aws_ecs_service" "admin_service" {
  depends_on       = [aws_alb_listener.alb_listener]
  name             = "admin-${var.Env-Name}"
  cluster          = aws_ecs_cluster.admin_cluster.id
  task_definition  = aws_ecs_task_definition.admin_task.arn
  desired_count    = var.instance-count
  launch_type      = "FARGATE"
  platform_version = "1.3.0"

  load_balancer {
    target_group_arn = aws_alb_target_group.admin_tg.arn
    container_name   = "admin"
    container_port   = "3000"
  }

  network_configuration {
    subnets = var.subnet-ids

    security_groups = [
      aws_security_group.admin_ec2_in.id,
      aws_security_group.admin_ec2_out.id,
    ]

    assign_public_ip = true
  }
}

resource "aws_alb_target_group" "admin_tg" {
  depends_on           = [aws_lb.admin_alb]
  name                 = "admin-${var.Env-Name}-fg-tg"
  port                 = "3000"
  protocol             = "HTTP"
  vpc_id               = var.vpc-id
  target_type          = "ip"
  deregistration_delay = 10

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/healthcheck"
  }

  lifecycle {
    create_before_destroy = true
  }
}
