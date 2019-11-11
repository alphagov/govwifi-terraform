resource "aws_ecr_repository" "database_backups" {
  name = "govwifi/database-backups"
}

resource "aws_cloudwatch_event_rule" "daily_databse_backup" {
  name                = "${var.Env-Name}-daily-database-backup"
  description         = "Triggers at 1am Daily"
  schedule_expression = "cron(0 1 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_log_group" "database_back_up_log_group" {
  name = "${var.Env-Name}-databse-backup-log-group"

  retention_in_days = 90
}

resource "aws_iam_role" "database_backup_scheduled_task_role" {
  name               = "${var.Env-Name}-database-backup-scheduled-task-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_events_role.json}"
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

resource "aws_iam_role" "database_backup_task_role" {
  name = "${var.Env-Name}-database-backup-task-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}