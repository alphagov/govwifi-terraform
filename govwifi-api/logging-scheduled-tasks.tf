resource "aws_iam_role" "logging-scheduled-task-role" {
  count = "${var.logging-enabled}"
  name  = "${var.Env-Name}-logging-scheduled-task-role"

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
  count = "${var.logging-enabled}"
  name  = "${var.Env-Name}-logging-scheduled-task-policy"
  role  = "${aws_iam_role.logging-scheduled-task-role.id}"

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.logging-api-scheduled-task.arn, "/:\\d+$/", ":*")}"
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
        },
        {
          "Effect": "Allow",
          "Action": [
            "s3:PutObject"
          ],
          "Resource": "arn:aws:s3:::${var.metrics-bucket-name}/*"
        }
    ]
}
DOC
}

resource "aws_cloudwatch_event_target" "logging-publish-weekly-statistics" {
  count     = "${var.logging-enabled}"
  target_id = "${var.Env-Name}-logging-weekly-statistics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.weekly_statistics_logging_event.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-scheduled-task.arn}"
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
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_weekly_statistics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "logging-publish-monthly-statistics" {
  count     = "${var.logging-enabled}"
  target_id = "${var.Env-Name}-logging-monthly-statistics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.monthly_statistics_logging_event.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-scheduled-task.arn}"
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
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_monthly_statistics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "logging-daily-session-deletion" {
  count     = "${var.logging-enabled}"
  target_id = "${var.Env-Name}-logging-daily-session-deletion"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_session_deletion_event.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-scheduled-task.arn}"
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
      "name": "logging",
      "command": ["bundle", "exec", "rake", "daily_session_deletion"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "gdpr-set-user-last-login" {
  count     = "${var.logging-enabled}"
  target_id = "${var.Env-Name}-gdpr-user-set-last-login"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_gdpr_set_user_last_login.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-scheduled-task.arn}"
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
      "name": "logging",
      "command": ["bundle", "exec", "rake", "update_yesterdays_last_login"]
    }
  ]
}
EOF
}

# new metrics
resource "aws_cloudwatch_event_target" "logging-publish-monthly-active-users-metrics" {
  count     = "${var.logging-enabled}"
  target_id = "${var.Env-Name}-logging-monthly-metrics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.monthly_active_users_metrics_event.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-scheduled-task.arn}"
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
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_monthly_metrics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "logging-publish-active-users-weekly-metrics" {
  count     = "${var.logging-enabled}"
  target_id = "${var.Env-Name}-logging-weekly-metrics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.weekly_active_users_metrics_event.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-scheduled-task.arn}"
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
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_weekly_metrics"]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "logging-publish-active-users-daily-metrics" {
  count     = "${var.logging-enabled}"
  target_id = "${var.Env-Name}-logging-daily-metrics"
  arn       = "${aws_ecs_cluster.api-cluster.arn}"
  rule      = "${aws_cloudwatch_event_rule.daily_active_users_metrics_event.name}"
  role_arn  = "${aws_iam_role.logging-scheduled-task-role.arn}"

  ecs_target = {
    task_count          = 1
    task_definition_arn = "${aws_ecs_task_definition.logging-api-scheduled-task.arn}"
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
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_daily_metrics"]
    }
  ]
}
EOF
}

resource "aws_ecs_task_definition" "logging-api-scheduled-task" {
  count                    = "${var.logging-enabled}"
  family                   = "logging-api-scheduled-task-${var.Env-Name}"
  task_role_arn            = "${aws_iam_role.logging-api-task-role.arn}"
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"

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
          "hostPort": 8080,
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "hostname": null,
      "essential": true,
      "entryPoint": null,
      "mountPoints": [],
      "name": "logging",
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
          "value": "${var.db-hostname}"
        },{
          "name": "USER_DB_NAME",
          "value": "govwifi_${var.env}_users"
        },{
          "name": "USER_DB_PASS",
          "value": "${var.user-db-password}"
        },{
          "name": "USER_DB_USER",
          "value": "${var.user-db-username}"
        },{
          "name": "USER_DB_HOSTNAME",
          "value": "${var.user-db-hostname}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.logging-sentry-dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
        },{
          "name": "PERFORMANCE_URL",
          "value": "${var.performance-url}"
        },{
          "name": "PERFORMANCE_DATASET",
          "value": "${var.performance-dataset}"
        },{
          "name": "PERFORMANCE_BEARER_ACTIVE_USERS",
          "value": "${var.performance-bearer-active-users}"
        },{
          "name": "PERFORMANCE_BEARER_UNIQUE_USERS",
          "value": "${var.performance-bearer-unique-users}"
        },{
          "name": "PERFORMANCE_BEARER_ROAMING_USERS",
          "value": "${var.performance-bearer-roaming-users}"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_BUCKET",
          "value": "govwifi-${var.rack-env}-admin"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY",
          "value": "ips-and-locations.json"
        },
        {
          "name": "S3_METRICS_BUCKET",
          "value": "${var.metrics-bucket-name}"
        }
      ],
      "links": null,
      "workingDirectory": null,
      "readonlyRootFilesystem": null,
      "image": "${var.logging-docker-image}",
      "command": null,
      "user": null,
      "dockerLabels": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.logging-api-log-group.name}",
          "awslogs-region": "${var.aws-region}",
          "awslogs-stream-prefix": "${var.Env-Name}-logging-api-docker-logs"
        }
      },
      "cpu": 0,
      "privileged": null,
      "expanded": true
    }
]
EOF
}
