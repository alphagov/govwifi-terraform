resource "aws_ecs_cluster" "device-wifi-frontend-cluster" {
  name = "${var.Env-Name}-device-wifi-frontend-cluster"
}

resource "aws_ecr_repository" "device-wifi-frontend-ecr" {
  count = "${var.ecr-repository-count}"
  name  = "devicewifi/frontend"
}

resource "aws_cloudwatch_log_group" "device-wifi-frontend-log-group" {
  name = "${var.Env-Name}-device-wifi-frontend-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecs_task_definition" "device-wifi-radius-task" {
  family = "device-wifi-radius-task-${var.Env-Name}"

  container_definitions = <<EOF
[
  {
    "volumesFrom": [],
    "memory": 2000,
    "extraHosts": null,
    "dnsServers": null,
    "disableNetworking": null,
    "dnsSearchDomains": null,
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
      }
    ],
    "hostname": null,
    "essential": true,
    "entryPoint": null,
    "mountPoints": [],
    "name": "frontend-radius",
    "ulimits": null,
    "dockerSecurityOptions": null,
    "environment": [
      {
        "name": "AUTHORISATION_API_BASE_URL",
        "value": "${var.auth-api-base-url}"
      },{
        "name": "LOGGING_API_BASE_URL",
        "value": "${var.logging-api-base-url}"
      },{
        "name": "RADIUS_CONFIG_WHITELIST_URL",
        "value": "https://s3.eu-west-2.amazonaws.com/govwifi-${var.rack-env}-admin/clients.conf"
      },{
        "name": "BACKEND_API_KEY",
        "value": "${var.shared-key}"
      },{
        "name": "HEALTH_CHECK_RADIUS_KEY",
        "value": "${var.healthcheck-radius-key}"
      },{
        "name": "SERVICE_DOMAIN",
        "value": "${var.Env-Subdomain}"
      },{
        "name": "RADIUSD_PARAMS",
        "value": "${var.radiusd-params}"
      },{
        "name": "RACK_ENV",
        "value": "${var.rack-env}"
      }
    ],
    "links": null,
    "workingDirectory": null,
    "readonlyRootFilesystem": null,
    "image": "${var.docker-image}",
    "command": null,
    "user": null,
    "dockerLabels": null,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${var.Env-Name}-device-wifi-frontend-docker-log-group",
        "awslogs-region": "${var.aws-region}",
        "awslogs-stream-prefix": "${var.Env-Name}-docker-logs"
      }
    },
    "cpu": 2000,
    "privileged": null,
    "expanded": true
  }
]
EOF
}

resource "aws_ecs_service" "device-wifi-frontend-service" {
  name            = "device-wifi-frontend-service-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.device-wifi-frontend-cluster.id}"
  task_definition = "${aws_ecs_task_definition.device-wifi-radius-task.arn}"
  desired_count   = "${var.radius-instance-count}"
}
