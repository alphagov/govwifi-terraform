resource "aws_iam_role" "logging-scheduled-task-role" {
  name = "${var.Env-Name}-logging-scheduled-task-role"
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

resource "aws_iam_role_policy" "logging-scheduled-task-policy" {
  name = "${var.Env-Name}-logging-scheduled-task-policy"
  role = "${aws_iam_role.logging-scheduled-task-role.id}"
  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.logging-api-task.arn, "/:\\d+$/", ":*")}"
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

resource "aws_cloudwatch_event_target" "logging-publish-daily-statistics" {
  target_id = "${var.Env-Name}-logging-daily-statistics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_statistics_event.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-task.arn}"
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_daily_statistics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "logging-publish-weekly-statistics" {
  target_id = "${var.Env-Name}-logging-weekly-statistics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.weekly_statistics_event.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-task.arn}"
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_weekly_statistics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "logging-publish-monthly-statistics" {
  target_id = "${var.Env-Name}-logging-monthly-statistics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.monthly_statistics_event.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-task.arn}"
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_monthly_statistics"]
    }
  ]
}
EOF
}
