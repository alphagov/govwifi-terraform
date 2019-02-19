resource "aws_ecs_cluster" "admin-cluster" {
  name = "${var.Env-Name}-admin-cluster"
}

resource "aws_cloudwatch_log_group" "admin-log-group" {
  name = "${var.Env-Name}-admin-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "govwifi-admin-ecr" {
  count = "${var.ecr-repository-count}"
  name  = "govwifi/admin"
}

resource "aws_ecs_task_definition" "admin-task" {
  family = "admin-task-${var.Env-Name}"
  requires_compatibilities = ["FARGATE"]
  task_role_arn = "${aws_iam_role.ecs-admin-instance-role.arn}"
  execution_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  cpu = "512"
  memory = "1024"
  network_mode = "awsvpc"

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
          "name": "DB_USER",
          "value": "${var.admin-db-user}"
        },{
          "name": "DB_PASS",
          "value": "${var.admin-db-password}"
        },{
          "name": "AUTHORISED_EMAIL_DOMAINS_REGEX",
          "value": ${jsonencode(var.authorised-email-domains-regex)}
        },{
          "name": "DB_NAME",
          "value": "govwifi_admin_${var.rack-env}"
        },{
          "name": "DB_HOST",
          "value": "${aws_db_instance.admin_db.address}"
        },{
          "name": "NOTIFY_API_KEY",
          "value": "${var.notify-api-key}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SECRET_KEY_BASE",
          "value": "${var.secret-key-base}"
        },{
          "name": "DEVISE_SECRET_KEY",
          "value": "${var.secret-key-base}"
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
          "value": "govwifi-${var.rack-env}-admin-mou"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_BUCKET",
          "value": "govwifi-${var.rack-env}-admin"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY",
          "value": "ips-and-locations.json"
        },{
          "name": "S3_SIGNUP_WHITELIST_BUCKET",
          "value": "govwifi-${var.rack-env}-admin"
        },{
          "name": "S3_SIGNUP_WHITELIST_OBJECT_KEY",
          "value": "signup-whitelist.conf"
        },{
          "name": "S3_WHITELIST_OBJECT_KEY",
          "value": "clients.conf"
        },{
          "name": "LOGGING_API_SEARCH_ENDPOINT",
          "value": "${var.logging-api-search-url}"
        },{
          "name": "RR_DB_USER",
          "value": "${var.rr-db-user}"
        },{
          "name": "RR_DB_PASS",
          "value": "${var.rr-db-password}"
        },{
          "name": "RR_DB_HOST",
          "value": "${var.rr-db-host}"
        },{
          "name": "RR_DB_NAME",
          "value": "${var.rr-db-name}"
        },{
          "name": "ZENDESK_API_ENDPOINT",
          "value": "${var.zendesk-api-endpoint}"
        },{
          "name": "ZENDESK_API_USER",
          "value": "${var.zendesk-api-user}"
        },{
          "name": "ZENDESK_API_TOKEN",
          "value": "${var.zendesk-api-token}"
        }
      ],
      "image": "${var.admin-docker-image}",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.admin-log-group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-admin-docker-logs"
        }
      },
      "expanded": true
    }
]
EOF
}

resource "aws_ecs_service" "admin-service" {
  depends_on      = ["aws_alb_listener.alb_listener"]
  name            = "admin-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.admin-cluster.id}"
  task_definition = "${aws_ecs_task_definition.admin-task.arn}"
  desired_count   = "${var.instance-count}"
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.admin-tg.arn}"
    container_name = "admin"
    container_port = "3000"
  }

  network_configuration {
    subnets = ["${var.subnet-ids}"]
    security_groups = ["${var.ec2-sg-list}"]
    assign_public_ip = true
  }
}


resource "aws_alb_target_group" "admin-tg" {
  depends_on   = ["aws_lb.admin-alb"]
  name     = "admin-${var.Env-Name}-fg-tg"
  port     = "3000"
  protocol = "HTTP"
  vpc_id   = "${var.vpc-id}"
  target_type = "ip"
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
