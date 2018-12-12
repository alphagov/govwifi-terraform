resource "aws_cloudwatch_event_rule" "daily_safe_restart" {
  name                = "${var.Env-Name}-daily-safe-restart"
  description         = "Triggers at midnight Daily"
  schedule_expression = "cron(0 0 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_log_group" "safe-restart-log-group" {
  name = "${var.Env-Name}-safe-restart-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "safe-restarter-ecr" {
  count = "${var.ecr-repository-count}"
  name  = "govwifi/safe-restarter"
}

resource "aws_ecs_task_definition" "safe-restart-task-definition" {
  family = "safe-restart-task-${var.Env-Name}"
  task_role_arn = "${aws_iam_role.safe-restart-task-role.arn}"

  container_definitions = <<EOF
[
    {
      "volumesFrom": [],
      "memory": 950,
      "extraHosts": null,
      "dnsServers": null,
      "disableNetworking": null,
      "dnsSearchDomains": null,
      "portMappings": [
        {
          "hostPort": 0,
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "hostname": null,
      "essential": true,
      "entryPoint": null,
      "mountPoints": [],
      "name": "safe-restart",
      "ulimits": null,
      "dockerSecurityOptions": null,
      "environment": [
        {
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        }
      ],
      "links": null,
      "workingDirectory": null,
      "readonlyRootFilesystem": null,
      "image": "${var.safe-restart-docker-image}",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.safe-restart-log-group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-safe-restart-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF
}

resource "aws_iam_role" "safe-restart-task-role" {
  count = "${var.safe-restart-enabled}"
  name = "${var.Env-Name}-safe-restart-task-role"

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

resource "aws_iam_role" "safe-restart-scheduled-task-role" {
  count = "${var.safe-restart-enabled}"
  name = "${var.Env-Name}-safe-restart-scheduled-task-role"
  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}

resource "aws_iam_role_policy" "safe-restart-task-policy" {
  count      = "${var.safe-restart-enabled}"
  name       = "${var.Env-Name}-safe-restart-task-policy"
  role       = "${aws_iam_role.safe-restart-task-role.id}"
  depends_on = ["aws_iam_role.safe-restart-task-role"]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:ListClusters",
        "ecs:ListTasks",
        "ecs:StopTask",
        "route53:ListHealthChecks",
        "route53:GetHealthCheckStatus"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "safe-restart-scheduled-task-policy" {
  count = "${var.safe-restart-enabled}"
  name = "${var.Env-Name}-safe-restart-scheduled-task-policy"
  role = "${aws_iam_role.safe-restart-scheduled-task-role.id}"
  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.safe-restart-task-definition.arn, "/:\\d+$/", ":*")}"
        },
        {
          "Effect": "Allow",
          "Action": "iam:PassRole",
          "Resource": [
            "*"
          ],
          "Condition": {
            "StringLike": {
              "iam:PassedToService": "ecs-tasks.amazonaws.com"
            }
          }
        }
    ]
}
DOC
}

resource "aws_cloudwatch_event_target" "daily-safe-restart" {
  count     = "${var.safe-restart-enabled}"
  target_id = "${var.Env-Name}-safe-restart"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_safe_restart.name}"
  role_arn  = "${aws_iam_role.safe-restart-scheduled-task-role.arn}"

  ecs_target = {
    task_count = 1
    task_definition_arn = "${aws_ecs_task_definition.safe-restart-task-definition.arn}"
    launch_type  = "EC2"
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "safe-restart",
      "command": ["bundle", "exec", "rake", "safe_restart[${var.rack-env}]"]
    }
  ]
}
EOF
}
