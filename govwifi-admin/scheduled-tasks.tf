resource "aws_iam_role" "scheduled_task" {
  name = "${var.Env-Name}-admin-scheduled-task-role"

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

resource "aws_iam_role_policy" "scheduled_task" {
  name = "${var.Env-Name}-admin-scheduled-task-policy"
  role = aws_iam_role.scheduled_task.id

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(
  aws_ecs_task_definition.admin-task.arn,
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

# rake cleanup:orphans

resource "aws_cloudwatch_event_rule" "daily_cleanup_orphan_users" {
  name                = "${var.Env-Name}-daily-cleanup-orphan-users"
  description         = "Triggers daily 03:15 UTC"
  schedule_expression = "cron(15 3 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "cleanup_orphan_admin_users" {
  target_id = "${var.Env-Name}-cleanup-orphan-admin-users"
  arn       = aws_ecs_cluster.admin-cluster.arn
  rule      = aws_cloudwatch_event_rule.daily_cleanup_orphan_users.name
  role_arn  = aws_iam_role.scheduled_task.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.admin-task.arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        [aws_security_group.admin-ec2-in.id],
        [aws_security_group.admin-ec2-out.id]
      )

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "admin",
      "command": ["bundle", "exec", "rake", "cleanup:orphans"]
    }
  ]
}
EOF

}

# rake backup:service_emails

resource "aws_cloudwatch_event_rule" "daily_backup_service_emails" {
  name                = "${var.Env-Name}-daily-backup-service-emails"
  description         = "Triggers daily 03:30 UTC"
  schedule_expression = "cron(30 3 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "admin_backup_service_emails" {
  target_id = "${var.Env-Name}-admin-backup-service-emails"
  arn       = aws_ecs_cluster.admin-cluster.arn
  rule      = aws_cloudwatch_event_rule.daily_backup_service_emails.name
  role_arn  = aws_iam_role.scheduled_task.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.admin-task.arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        [aws_security_group.admin-ec2-in.id],
        [aws_security_group.admin-ec2-out.id]
      )

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "admin",
      "command": ["bundle", "exec", "rake", "backup:service_emails"]
    }
  ]
}
EOF

}
