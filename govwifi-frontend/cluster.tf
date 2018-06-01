# Create ECS Cluster

resource "aws_ecs_cluster" "frontend-cluster" {
  name = "${var.Env-Name}-frontend-cluster"
}

resource "aws_cloudwatch_log_group" "frontend-log-group" {
  name = "${var.Env-Name}-frontend-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecs_task_definition" "radius-task" {
  family = "radius-task-${var.Env-Name}"

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
        "name": "BACKEND_BASEURL",
        "value": "${var.backend-base-url}"
      },{
        "name": "ALLOWED_SITES_API_BASE_URL",
        "value": "${var.allowed-sites-api-base-url}"
      },{
        "name": "API_BASE_URL",
        "value": "${var.api-base-url}"
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
        "awslogs-group": "${aws_cloudwatch_log_group.frontend-log-group.name}",
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

resource "aws_ecs_service" "frontend-service" {
  name            = "frontend-service-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.frontend-cluster.id}"
  task_definition = "${aws_ecs_task_definition.radius-task.arn}"
  desired_count   = "${var.radius-instance-count}"

  # We can not add this role until a loadbalancer is set up.

  #iam_role        = "${aws_iam_role.ecs-service-role.arn}"

  #depends_on = ["aws_iam_role_policy.ecs-service-role-policy"]
}
