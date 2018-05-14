resource "aws_ecs_cluster" "allowed-sites-api-cluster" {
  name = "${var.Env-Name}-allowed-sites-api-cluster"
}

resource "aws_cloudwatch_log_group" "allowed-sites-api-log-group" {
  name = "${var.Env-Name}-allowed-sites-api-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "govwifi-allowed-sites-api-ecr" {
  name = "govwifi/allowed-sites-api"
}

resource "aws_ecs_task_definition" "allowed-sites-api-task" {
  family = "allowed-sites-api-task-${var.Env-Name}"

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
          "hostPort": 80,
          "containerPort": 80,
          "protocol": "tcp"
        },
        {
          "hostPort": 8080,
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "hostname": null,
      "essential": true,
      "entryPoint": null,
      "mountPoints": [],
      "name": "backend",
      "ulimits": null,
      "dockerSecurityOptions": null,
      "environment": [
        {
          "name": "RR_DB_NAME",
          "value": "govwifi_${var.Env-Name}"
        },{
          "name": "RR_DB_PASS",
          "value": "${var.db-password}"
        },{
          "name": "RR_DB_USER",
          "value": "${var.db-user}"
        },{
          "name": "RR_DB_HOSTNAME",
          "value": "rr.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
        },{
          "name": "FRONTEND_API_KEY",
          "value": "${var.shared-key}"
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
          "awslogs-group": "${aws_cloudwatch_log_group.allowed-sites-api-log-group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-allowed-sites-api-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF
}

resource "aws_ecs_service" "allowed-sites-api-service" {
  name            = "allowed-sites-api-service-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.allowed-sites-api-cluster.id}"
  task_definition = "${aws_ecs_task_definition.allowed-sites-api-task.arn}"
  desired_count   = "${var.backend-instance-count}"
  iam_role        = "${var.ecs-service-role}"

  load_balancer {
    elb_name       = "${aws_elb.allowed-sites-api-elb.name}"
    container_name = "backend"
    container_port = 80
  }
}
