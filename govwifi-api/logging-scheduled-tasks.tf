resource "aws_iam_role" "logging_scheduled_task_role" {
  count = var.logging-enabled
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

resource "aws_iam_role_policy" "logging_scheduled_task_policy" {
  count = var.logging-enabled
  name  = "${var.Env-Name}-logging-scheduled-task-policy"
  role  = aws_iam_role.logging_scheduled_task_role[0].id

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(
  aws_ecs_task_definition.logging_api_scheduled_task[0].arn,
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

resource "aws_cloudwatch_event_target" "logging_daily_session_deletion" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-logging-daily-session-deletion"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.daily_session_deletion_event[0].name
  role_arn  = aws_iam_role.logging_scheduled_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

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

resource "aws_cloudwatch_event_target" "gdpr_set_user_last_login" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-gdpr-user-set-last-login"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.daily_gdpr_set_user_last_login[0].name
  role_arn  = aws_iam_role.logging_scheduled_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

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

resource "aws_cloudwatch_event_target" "hourly_request_statistics" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-publish-hourly-request-statistics"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.hourly_request_statistics_event[0].name
  role_arn  = aws_iam_role.logging_scheduled_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "logging",
      "command": ["bundle", "exec", "rake", "send_request_statistics"]
    }
  ]
}
EOF

}

# new metrics
resource "aws_cloudwatch_event_target" "publish_monthly_metrics_logging" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-logging-monthly-metrics"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.monthly_metrics_logging_event[0].name
  role_arn  = aws_iam_role.logging_scheduled_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

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

resource "aws_cloudwatch_event_target" "publish_weekly_metrics_logging" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-logging-weekly-metrics"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.weekly_metrics_logging_event[0].name
  role_arn  = aws_iam_role.logging_scheduled_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

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

resource "aws_cloudwatch_event_target" "publish_daily_metrics_logging" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-logging-daily-metrics"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.daily_metrics_logging_event[0].name
  role_arn  = aws_iam_role.logging_scheduled_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

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

resource "aws_cloudwatch_event_target" "publish_monthly_metrics_to_elasticsearch" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-logging-monthly-metrics-to-elasticsearch"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.monthly_metrics_logging_event[0].name
  role_arn  = aws_iam_role.logging_scheduled_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_monthly_metrics_to_elasticsearch"]
    }
  ]
}
EOF

}

resource "aws_cloudwatch_event_target" "publish_weekly_metrics_to_elasticsearch" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-logging-weekly-metrics-to-elasticsearch"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.weekly_metrics_logging_event[0].name
  role_arn  = aws_iam_role.logging_scheduled_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_weekly_metrics_to_elasticsearch"]
    }
  ]
}
EOF

}

resource "aws_cloudwatch_event_target" "publish_daily_metrics_to_elasticsearch" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-logging-daily-metrics-to-elasticsearch"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.daily_metrics_logging_event[0].name
  role_arn  = aws_iam_role.logging_scheduled_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "logging",
      "command": ["bundle", "exec", "rake", "publish_daily_metrics_to_elasticsearch"]
    }
  ]
}
EOF

}

resource "aws_ecs_task_definition" "logging_api_scheduled_task" {
  count                    = var.logging-enabled
  family                   = "logging-api-scheduled-task-${var.Env-Name}"
  task_role_arn            = aws_iam_role.logging_api_task_role[0].arn
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
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
          "name": "DB_HOSTNAME",
          "value": "${var.db-hostname}"
        },{
          "name": "USER_DB_NAME",
          "value": "govwifi_${var.env}_users"
        },{
          "name": "USER_DB_HOSTNAME",
          "value": "${var.user-db-hostname}"
        },{
          "name": "RACK_ENV",
          "value": "${var.rack-env}"
        },{
          "name": "SENTRY_CURRENT_ENV",
          "value": "${var.sentry-current-env}"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.logging-sentry-dsn}"
        },{
          "name": "ENVIRONMENT_NAME",
          "value": "${var.Env-Name}"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_BUCKET",
          "value": "govwifi-${var.rack-env}-admin"
        },{
          "name": "S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY",
          "value": "ips-and-locations.json"
        },{
          "name": "S3_METRICS_BUCKET",
          "value": "${var.metrics-bucket-name}"
        }
      ],
      "secrets": [
        {
          "name": "DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:password::"
        },{
          "name": "DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.session_db.arn}:username::"
        },{
          "name": "USER_DB_PASS",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:password::"
        },{
          "name": "USER_DB_USER",
          "valueFrom": "${data.aws_secretsmanager_secret_version.users_db.arn}:username::"
        },{
          "name": "VOLUMETRICS_ENDPOINT",
          "valueFrom": "${data.aws_secretsmanager_secret_version.volumetrics_elasticsearch_endpoint.arn}:endpoint::"
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
          "awslogs-group": "${aws_cloudwatch_log_group.logging_api_log_group[0].name}",
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

resource "aws_cloudwatch_event_target" "sync_s3_to_elasticsearch" {
  count     = var.logging-enabled
  target_id = "${var.Env-Name}-sync-s3-to-elasticsearch"
  arn       = aws_ecs_cluster.api_cluster.arn
  rule      = aws_cloudwatch_event_rule.sync_s3_to_elasticsearch_event[0].name
  role_arn  = aws_iam_role.logging_api_task_role[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.logging_api_scheduled_task[0].arn
    launch_type         = "FARGATE"
    platform_version    = "1.3.0"

    network_configuration {
      subnets = var.subnet-ids

      security_groups = concat(
        var.backend-sg-list,
        [aws_security_group.api_in.id],
        [aws_security_group.api_out.id]
      )

      assign_public_ip = true
    }
  }

  input = <<EOF
{
  "containerOverrides": [
    {
      "name": "logging",
      "command": ["bundle", "exec", "rake", "sync_s3_volumetrics"]
    }
  ]
}
EOF

}
