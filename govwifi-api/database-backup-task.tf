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
  task_role_arn            = aws_iam_role.backup-rds-to-s3-task-role[0].arn
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 8192
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
          "name": "BACKUP_ENDPOINT_URL",
          "value": ""
        },{
          "name": "S3_BUCKET",
          "value": "govwifi-${var.Env-Name}-${lower(var.aws-region-name)}-mysql-backup-data"
        }
      ],
      "secrets": [
        {
          "name": "ADMIN_DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.admin_db.arn}:password::"
        },{
          "name": "ADMIN_DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.admin_db.arn}:username::"
        },{
          "name": "ADMIN_DB_NAME",
          "valueFrom": "${data.aws_secretsmanager_secret_version.admin_db.arn}:dbname::"
        },{
          "name": "ADMIN_DB_HOSTNAME",
          "valueFrom": "${data.aws_secretsmanager_secret_version.admin_db.arn}:host::"
        },{
          "name": "ENCRYPTION_KEY",
          "valueFrom": "${data.aws_secretsmanager_secret_version.database_s3_encryption.arn}:key::"
        },{
          "name": "USERS_DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:password::"
        },{
          "name": "USERS_DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:username::"
        },{
          "name": "USERS_DB_NAME",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:dbname::"
        },{
          "name": "USERS_DB_HOSTNAME",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:host::"
        },{
          "name": "WIFI_DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:password::"
        },{
          "name": "WIFI_DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:username::"
        },{
          "name": "WIFI_DB_NAME",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:dbname::"
        },{
          "name": "WIFI_DB_HOSTNAME",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:host::"
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
      "Sid": "sid1",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
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
      "Sid": "sid1",
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
      "Sid": "sid1",
      "Effect": "Allow",
      "Action": [
        "ecs:ListClusters",
        "ecs:ListTasks",
        "ecs:StopTask",
        "route53:ListHealthChecks",
        "route53:GetHealthCheckStatus"
      ],
      "Resource": "*"
  }, {
      "Sid": "sid2",
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets",
        "s3:ListBucket",
        "s3:HeadBucket"
      ],
      "Resource": "*"
  }, {
      "Sid": "sid3",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:kms:eu-west-2:${var.aws-account-id}:key/*",
        "arn:aws:s3:::govwifi-${var.Env-Name}-${lower(var.aws-region-name)}-mysql-backup-data",
        "arn:aws:s3:::govwifi-${var.Env-Name}-${lower(var.aws-region-name)}-mysql-backup-data/*"
      ]
  }, {
      "Sid": "sid4",
      "Effect": "Allow",
      "Action": [
        "kms:GenerateDataKey*",
        "kms:Encrypt", 
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:DescribeKey"
      ],
      "Resource": "arn:aws:kms:eu-west-2:${var.aws-account-id}:key/*",
      "Condition": {
        "StringLike": {
          "kms:RequestAlias": "alias/${var.Env-Name}_mysql_rds_backup_s3_key"
        }
      }
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
      "Sid": "sid0",
          "Effect": "Allow",
          "Action": "ecs:RunTask",
          "Resource": "${replace(aws_ecs_task_definition.backup-rds-to-s3-task-definition[0].arn, "/:\\d+$/", ":*", )}"
    },{
      "Sid": "sid1",
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
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api-in.id],
        [aws_security_group.api-out.id],
      )

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "backup-rds-to-s3",
      "command": ["./database_backup.sh"]
    }
  ]
}
EOF

}

