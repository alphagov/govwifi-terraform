resource "aws_cloudwatch_event_rule" "daily_database_backup" {
  name                = "${var.Env-Name}-daily-database-backup"
  description         = "Triggers at 1am Daily"
  schedule_expression = "cron(0 1 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_log_group" "database_backup_log_group" {
  name = "${var.Env-Name}-database-backup-log-group"

  retention_in_days = 90
}

resource "aws_ecr_repository" "database_backups" {
  name = "govwifi/database-backup"
}

resource "aws_ecs_task_definition" "db_backup_task_definition" {
  family                   = "database-backup-${var.Env-Name}"
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  task_role_arn            = "${aws_iam_role.database_backup_task_role.arn}"
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
      "name": "database-backup",
      "ulimits": null,
      "dockerSecurityOptions": null,
      "environment": [
        {
          "name": "WIFI_DB_HOST",
          "value": "${var.db-hostname}"
        },{
          "name": "WIFI_DB_USER",
          "value": "${var.db-user}"
        },{
          "name": "WIFI_DB_PASS",
          "value": "${var.db-password}"
        },{
          "name": "WIFI_DB_NAME",
          "value": "${var.db-name}"
        },{
          "name": "USERS_DB_HOST",
          "value": "${var.user-db-hostname}"
        },{
          "name": "USERS_DB_USER",
          "value": "${var.user-db-username}"
        },{
          "name": "USERS_DB_PASS",
          "value": "${var.user-db-password}"
        },{
          "name": "USERS_DB_NAME",
          "value": "${var.user-db-name}"
        },{
          "name": "ADMIN_DB_HOST",
          "value": "${var.admin-db-hostname}"
        },{
          "name": "ADMIN_DB_USER",
          "value": "${var.admin-db-username}"
        },{
          "name": "ADMIN_DB_PASS",
          "value": "${var.admin-db-password}"
        },{
          "name": "ADMIN_DB_NAME",
          "value": "${var.admin-db-name}"
        },{
          "name": "S3_BUCKET",
          "value": "${aws_s3_bucket.database_backups.bucket}"
        }
      ],
      "links": null,
      "workingDirectory": null,
      "readonlyRootFilesystem": null,
      "image": "",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.database_backup_log_group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-database-backup-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF
}

resource "aws_iam_role" "database_backup_task_role" {
  name               = "${var.Env-Name}-database-backup-task-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_task_role.json}"
}

resource "aws_iam_role" "database_backup_scheduled_task_role" {
  name               = "${var.Env-Name}-database-backup-scheduled-task-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_events_role.json}"
}

resource "aws_iam_role_policy" "database_backup_task_role_policy" {
  name   = "${var.aws-region-name}-database-backup-bucket-${var.Env-Name}"
  policy = "${data.aws_iam_policy_document.access_database_backup_bucket.json}"
  role   = "${aws_iam_role.database_backup_task_role.id}"
  depends_on = ["aws_iam_role.database_backup_task_role"]
}

resource "aws_iam_role_policy" "databse_backup_schedule_task_role_policy" {
  name   = "${var.Env-Name}-safe-restart-scheduled-task-policy"
  policy = "${data.aws_iam_policy_document.pass_role_to_service.json}"
  role   = "${aws_iam_role.database_backup_scheduled_task_role.id}"
}

data "aws_iam_policy_document" "assume_events_role" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "assume_task_role" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type = "Service"
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "access_database_backup_bucket" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.database_backups.arn}",
      "${aws_s3_bucket.database_backups.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "pass_role_to_service" {

  statement {
    effect = "Allow"
    actions = ["ecs:RunTask"]
    resources = ["${replace(aws_ecs_task_definition.db_backup_task_definition.arn, "/:\\d+$/", ":*")}"]
  }

  statement {
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = ["*"]

    condition {
      test = "StringLike"
      values = ["iam:PassedToService"]
      variable = "ecs-tasks.amazonaws.com"
    }
  }
}

resource "aws_cloudwatch_event_target" "daily_database_backup" {
  target_id = "${var.Env-Name}-database-backup"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_database_backup.name}"
  role_arn  = "${aws_iam_role.database_backup_scheduled_task_role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.db_backup_task_definition.arn}"
    launch_type         = "FARGATE"

    network_configuration = {
      subnets = ["${var.subnet-ids}"]

      security_groups = [
        "${var.backend-sg-list}",
        "${aws_security_group.api-in.id}",
        "${aws_security_group.api-out.id}",
      ]

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "database-backup",
      "command": ["/bin/sh", "/govwifi-backup.sh"]
    }
  ]
}
EOF
}
