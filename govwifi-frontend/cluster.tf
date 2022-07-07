# Create ECS Cluster

resource "aws_ecs_cluster" "frontend_cluster" {
  name = "${var.env_name}-frontend-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "frontend_log_group" {
  name = "${var.env_name}-frontend-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "govwifi_frontend_ecr" {
  count = var.create_ecr
  name  = "govwifi/frontend"
}

resource "aws_ecr_repository" "govwifi_frontend_base_ecr" {
  count = var.create_ecr
  name  = "govwifi/frontend-base"
}

resource "aws_ecr_repository" "govwifi_raddb_ecr" {
  count = var.create_ecr
  name  = "govwifi/raddb"
}

resource "aws_ecs_task_definition" "radius_task" {
  family             = "radius-task-${var.env_name}"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  volume {
    name = "raddb-certs"
  }

  container_definitions = <<EOF
[
  {
    "memory": 1500,
    "portMappings": [
      {
        "hostPort": 8080,
        "containerPort": 80,
        "protocol": "tcp"
      },
      {
        "hostPort": 3000,
        "containerPort": 3000,
        "protocol": "tcp"
      },
      {
        "hostPort": 1812,
        "containerPort": 1812,
        "protocol": "udp"
      },
      {
        "hostPort": 1813,
        "containerPort": 1813,
        "protocol": "udp"
      },
      {
        "hostPort": 9812,
        "containerPort": 9812,
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "mountPoints": [
      {
        "sourceVolume": "raddb-certs",
        "containerPath": "/etc/raddb/certs"
      }
    ],
    "name": "frontend-radius",
    "environment": [
      {
        "name": "AUTHORISATION_API_BASE_URL",
        "value": "${var.auth_api_base_url}"
      },{
        "name": "LOGGING_API_BASE_URL",
        "value": "${var.logging_api_base_url}"
      },{
        "name": "RADIUSD_PARAMS",
        "value": "${var.radiusd_params}"
      },{
        "name": "RACK_ENV",
        "value": "${var.rack_env}"
      },{
        "name": "SERVICE_DOMAIN",
        "value": "${var.env_subdomain}"
      },{
        "name": "SENTRY_CURRENT_ENV",
        "value": "${var.sentry_current_env}"
      }
    ],
    "secrets": [
      {
        "name": "BACKEND_API_KEY",
        "valueFrom": "${data.aws_secretsmanager_secret_version.shared_key.arn}:shared-key::"
      },{
        "name": "HEALTH_CHECK_IDENTITY",
        "valueFrom": "${data.aws_secretsmanager_secret_version.healthcheck.arn}:identity::"
      },{
        "name": "HEALTH_CHECK_PASSWORD",
        "valueFrom": "${data.aws_secretsmanager_secret_version.healthcheck.arn}:pass::"
      },{
        "name": "HEALTH_CHECK_RADIUS_KEY",
        "valueFrom": "${data.aws_secretsmanager_secret_version.healthcheck.arn}:key::"
      },{
        "name": "HEALTH_CHECK_SSID",
        "valueFrom": "${data.aws_secretsmanager_secret_version.healthcheck.arn}:ssid::"
      }
    ],
    "image": "${var.frontend_docker_image}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.frontend_log_group.name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.env_name}-docker-logs"
      }
    },
    "cpu": 1000,
    "expanded": true,
    "dependsOn": [
      {
        "containerName": "populate-radius-certs",
        "condition": "SUCCESS"
      }
    ]
  },
  {
    "essential": false,
    "mountPoints": [
      {
        "sourceVolume": "raddb-certs",
        "containerPath": "/etc/raddb/certs"
      }
    ],
    "name": "populate-radius-certs",
    "environment": [
      {
        "name": "WHITELIST_BUCKET",
        "value": "s3://${var.admin_app_data_s3_bucket_name}"
      },{
        "name": "ALLOWLIST_BUCKET",
        "value": "s3://${var.admin_app_data_s3_bucket_name}"
      },{
        "name": "CERT_STORE_BUCKET",
        "value": "s3://${aws_s3_bucket.frontend_cert_bucket.bucket}"
      }
    ],
    "image": "${var.raddb_docker_image}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.frontend_log_group.name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.env_name}-docker-logs"
      }
    },
    "memory": 1500,
    "cpu": 1000,
    "expanded": true
  }
]
EOF

}

resource "aws_ecs_service" "frontend_service" {
  name            = "frontend-service-${var.env_name}"
  cluster         = aws_ecs_cluster.frontend_cluster.id
  task_definition = aws_ecs_task_definition.radius_task.arn
  desired_count   = var.radius_instance_count

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}
