# Create ECS Cluster

resource "aws_ecs_cluster" "backend-cluster" {
  name = "${var.Env-Name}-backend-cluster"
}

resource "aws_cloudwatch_log_group" "backend-log-group" {
  name = "${var.Env-Name}-backend-docker-log-group"
  #keep the logs forever
  retention_in_days = 0
}

resource "aws_ecs_task_definition" "backend-task" {
  family = "backend-task-${var.Env-Name}"

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
          "value": "db.${lower(var.aws-region-name)}.${var.Env-Name}${var.Env-Subdomain}.service.gov.uk"
        },{
          "name": "CACHE_HOSTNAME",
          "value": "cache.${lower(var.aws-region-name)}.${var.Env-Name}${var.Env-Subdomain}.service.gov.uk"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
        },{
          "name": "RADIUS_HOSTNAME",
          "value": "radius*n*.${var.Env-Name}${var.Env-Subdomain}.service.gov.uk"
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
          "awslogs-group": "${aws_cloudwatch_log_group.backend-log-group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF
}

resource "aws_ecs_service" "backend-service" {
  name            = "backend-service-${var.Env-Name}"
  cluster         = "${aws_ecs_cluster.backend-cluster.id}"
  task_definition = "${aws_ecs_task_definition.backend-task.arn}"
  desired_count   = "${var.backend-instance-count}"
  iam_role        = "${aws_iam_role.ecs-service-role.arn}"

  #depends_on = ["aws_iam_role_policy.ecs-service-role-policy"]

  load_balancer {
    elb_name       = "${aws_elb.backend-elb.name}"
    container_name = "backend"
    container_port = 80
  }
}
