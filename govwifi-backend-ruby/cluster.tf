resource "aws_ecs_cluster" "backend-ruby-cluster" {
  name = "${var.Env-Name}-backend-ruby-cluster"
}

resource "aws_cloudwatch_log_group" "backend-ruby-log-group" {
  name = "${var.Env-Name}-backend-ruby-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "govwifi-backend-ruby-ecr" {
  name = "govwifi/backend-ruby"
}

resource "aws_ecs_task_definition" "backend-ruby-task" {
  family = "backend-ruby-task-${var.Env-Name}"

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
          "value": "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
        },{
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
          "name": "CACHE_HOSTNAME",
          "value": "cache.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
        },{
          "name": "RADIUS_HOSTNAME",
          "value": "radius*n*.${var.Env-Subdomain}.service.gov.uk"
        },{
          "name": "RADIUS_SERVER_IPS",
          "value": "${var.radius-server-ips}"
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
          "awslogs-group": "${aws_cloudwatch_log_group.backend-ruby-log-group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-ruby-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF
}

resource "aws_ecs_service" "backend-ruby-service" {
  name            = "backend-ruby-service-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.backend-ruby-cluster.id}"
  task_definition = "${aws_ecs_task_definition.backend-ruby-task.arn}"
  desired_count   = "${var.backend-instance-count}"
  iam_role        = "${var.ecs-service-role}"

  load_balancer {
    elb_name       = "${aws_elb.backend-ruby-elb.name}"
    container_name = "backend"
    container_port = 80
  }
}
