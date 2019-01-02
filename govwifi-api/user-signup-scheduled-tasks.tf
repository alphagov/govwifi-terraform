
resource "aws_iam_role" "user-signup-scheduled-task-role" {
  count = "${var.user-signup-enabled}"
  name = "${var.Env-Name}-user-signup-scheduled-task-role"
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

resource "aws_iam_role_policy" "user-signup-scheduled-task-policy" {
  count = "${var.user-signup-enabled}"
  name = "${var.Env-Name}-user-signup-scheduled-task-policy"
  role = "${aws_iam_role.user-signup-scheduled-task-role.id}"
  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.user-signup-api-task.arn, "/:\\d+$/", ":*")}"
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

resource "aws_cloudwatch_event_target" "user-signup-publish-daily-statistics" {
  count     = "${var.user-signup-enabled}"
  target_id = "${var.Env-Name}-user-signup-daily-statistics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_statistics_user_signup_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-task.arn}"
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "publish_daily_statistics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "user-signup-publish-weekly-statistics" {
  count     = "${var.user-signup-enabled}"
  target_id = "${var.Env-Name}-user-signup-weekly-statistics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.weekly_statistics_user_signup_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-task.arn}"
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "publish_weekly_statistics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "user-signup-daily-user-deletion" {
  target_id = "${var.Env-Name}-user-signup-daily-user-deletion"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_user_deletion_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-task.arn}"

    network_configuration = {
      security_groups = ["${var.backend-sg-list}"]
      subnets         = ["${var.subnet-ids}"]
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "logging",
      "command": ["bundle", "exec", "rake", "delete_users"]
    }
  ]
}
EOF
}
