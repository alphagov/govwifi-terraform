resource "aws_cloudwatch_event_rule" "backup-rds-to-s3" {
  count               = var.backup_mysql_rds ? 1 : 0
  name                = "${var.Env-Name}-backup-rds-to-s3"
  description         = "Triggers at 00:30 UTC Daily"
  schedule_expression = "cron(30 0 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_log_group" "backup-rds-to-s3-log-group" {
  count = var.backup_mysql_rds ? 1 : 0
  name  = "${var.Env-Name}-backup-rds-to-s3-docker-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "database-backup-ecr" {
  count = var.ecr-repository-count
  name  = "govwifi/database-backup"
}

resource "aws_ecs_task_definition" "backup-rds-to-s3-task-definition" {
  count                    = var.backup_mysql_rds ? 1 : 0
  family                   = "backup-rds-to-s3-task-${var.Env-Name}"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.backup-rds-to-s3-task-role[0].arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 1024
  network_mode             = "awsvpc"

  container_definitions = <<EOF
[
    {
      "volumesFrom": [],
      "memory": 1024,
      "extraHosts": null,
      "dnsServers": null,
      "disableNetworking": null,
      "dnsSearchDomains": null,
      "portMappings": [
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
      "name": "backup-rds-to-s3",
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
      "image": "${var.backup-rds-to-s3-docker-image}",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.backup-rds-to-s3-log-group[0].name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-backup-rds-to-s3-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF

}

resource "aws_iam_role" "backup-rds-to-s3-task-role" {
  count = var.backup_mysql_rds ? 1 : 0
  name  = "${var.Env-Name}-backup-rds-to-s3-task-role"

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

resource "aws_iam_role" "backup-rds-to-s3-scheduled-task-role" {
  count = var.backup_mysql_rds ? 1 : 0
  name  = "${var.Env-Name}-backup-rds-to-s3-scheduled-task-role"

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

resource "aws_iam_role_policy" "backup-rds-to-s3-task-policy" {
  count      = var.backup_mysql_rds ? 1 : 0
  name       = "${var.Env-Name}-backup-rds-to-s3-task-policy"
  role       = aws_iam_role.backup-rds-to-s3-task-role[0].id
  depends_on = [aws_iam_role.backup-rds-to-s3-task-role]

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

resource "aws_iam_role_policy" "backup-rds-to-s3-scheduled-task-policy" {
  count = var.backup_mysql_rds ? 1 : 0
  name  = "${var.Env-Name}-backup-rds-to-s3-scheduled-task-policy"
  role  = aws_iam_role.backup-rds-to-s3-scheduled-task-role[0].id

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(
  aws_ecs_task_definition.backup-rds-to-s3-task-definition[0].arn,
  "/:\\d+$/",
  ":*",
)}"
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

resource "aws_cloudwatch_event_target" "backup-rds-to-s3" {
  count     = var.backup_mysql_rds ? 1 : 0
  target_id = "${var.Env-Name}-backup-rds-to-s3"
  arn       = aws_ecs_cluster.api-cluster.arn
  rule      = aws_cloudwatch_event_rule.backup-rds-to-s3[0].name
  role_arn  = aws_iam_role.backup-rds-to-s3-scheduled-task-role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.backup-rds-to-s3-task-definition[0].arn
    launch_type         = "FARGATE"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api-in.id],
        [aws_security_group.api-out.id]
      )

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "database-backup",
      "command": ["bundle", "exec", "rake", "database_backup.sh[${var.rack-env}]"]
    }
  ]
}
EOF

}
