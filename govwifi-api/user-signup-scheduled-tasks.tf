resource "aws_cloudwatch_event_target" "retrieve-notifications" {
  count     = "${var.user-signup-enabled}"
  target_id = "${var.Env-Name}-retrieve-notifications"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.retrieve_notifications_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-scheduled-task.arn}"
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
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "retrieve_notifications"]
    }
  ]
}
EOF
}

resource "aws_iam_role" "user-signup-scheduled-task-role" {
  count = "${var.user-signup-enabled}"
  name  = "${var.Env-Name}-user-signup-scheduled-task-role"

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
  name  = "${var.Env-Name}-user-signup-scheduled-task-policy"
  role  = "${aws_iam_role.user-signup-scheduled-task-role.id}"

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.user-signup-api-scheduled-task.arn, "/:\\d+$/", ":*")}"
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
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-scheduled-task.arn}"
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
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-scheduled-task.arn}"
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
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "publish_weekly_statistics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "user-signup-publish-monthly-statistics" {
  count     = "${var.user-signup-enabled}"
  target_id = "${var.Env-Name}-user-signup-monthly-statistics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.monthly_statistics_user_signup_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-scheduled-task.arn}"
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
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "publish_monthly_statistics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "publish-daily-metrics-user-signup" {
  count     = "${var.user-signup-enabled}"
  target_id = "${var.Env-Name}-user-signup-daily-metrics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_metrics_user_signup_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-scheduled-task.arn}"
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
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "publish_daily_metrics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "publish-weekly-metrics-user-signup" {
  count     = "${var.user-signup-enabled}"
  target_id = "${var.Env-Name}-user-signup-weekly-metrics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.weekly_metrics_user_signup_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-scheduled-task.arn}"
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
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "publish_weekly_metrics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "publish-monthly-metrics-user-signup" {
  count     = "${var.user-signup-enabled}"
  target_id = "${var.Env-Name}-user-signup-monthly-metrics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.monthly_metrics_user_signup_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-scheduled-task.arn}"
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
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "publish_monthly_metrics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "user-signup-daily-user-deletion" {
  count     = "${var.user-signup-enabled}"
  target_id = "${var.Env-Name}-user-signup-daily-user-deletion"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_user_deletion_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-scheduled-task.arn}"
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
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "delete_inactive_users"]
    }
  ]
}
EOF
}

resource "aws_ecs_task_definition" "user-signup-api-scheduled-task" {
  count                    = "${var.user-signup-enabled}"
  family                   = "user-signup-api-scheduled-task-${var.Env-Name}"
  task_role_arn            = "${aws_iam_role.user-signup-api-task-role.arn}"
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
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
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "hostname": null,
      "essential": true,
      "entryPoint": null,
      "mountPoints": [],
      "name": "user-signup",
      "ulimits": null,
      "dockerSecurityOptions": null,
      "environment": [
        {
          "name": "DB_NAME",
          "value": "govwifi_${var.env}_users"
        },{
          "name": "DB_PASS",
          "value": "${var.user-db-password}"
        },{
          "name": "DB_USER",
          "value": "${var.user-db-username}"
        },{
          "name": "DB_HOSTNAME",
          "value": "${var.user-db-hostname}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.user-signup-sentry-dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
        },{
          "name": "NOTIFY_API_KEY",
          "value": "${var.notify-api-key}"
        },{
          "name": "PERFORMANCE_URL",
          "value": "${var.performance-url}"
        },{
          "name": "PERFORMANCE_DATASET",
          "value": "${var.performance-dataset}"
        },{
          "name": "PERFORMANCE_BEARER_VOLUMETRICS",
          "value": "${var.performance-bearer-volumetrics}"
        },{
          "name": "PERFORMANCE_BEARER_COMPLETION_RATE",
          "value": "${var.performance-bearer-completion-rate}"
        },{
          "name": "FIRETEXT_TOKEN",
          "value": "${var.firetext-token}"
        },{
          "name": "GOVNOTIFY_BEARER_TOKEN",
          "value": "${var.govnotify-bearer-token}"
        },{
          "name": "S3_METRICS_BUCKET",
          "value": "${var.metrics-bucket-name}"
        }
      ],
      "links": null,
      "workingDirectory": null,
      "readonlyRootFilesystem": null,
      "image": "${var.user-signup-docker-image}",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.user-signup-api-log-group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-user-signup-api-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF
}

resource "aws_cloudwatch_event_target" "active-users-signup-surveys" {
  count     = "${var.user-signup-enabled}"
  target_id = "${var.Env-Name}-active-users-signup-surveys"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.active_users_signup_survey_event.name}"
  role_arn  = "${aws_iam_role.user-signup-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.user-signup-api-scheduled-task.arn}"
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
      "name": "user-signup",
      "command": ["bundle", "exec", "rake", "send_active_users_signup_survey"]
    }
  ]
}
EOF
}
