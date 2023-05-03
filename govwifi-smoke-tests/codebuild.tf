resource "aws_codebuild_project" "smoke_tests" {
  name          = "govwifi-smoke-tests"
  description   = "This project runs the govwifi tests at regular intervals"
  build_timeout = "5"
  service_role  = aws_iam_role.govwifi_codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "DOCKER_HUB_AUTHTOKEN_ENV"
      value = data.aws_secretsmanager_secret_version.docker_hub_authtoken.secret_string
    }

    environment_variable {
      name  = "DOCKER_HUB_USERNAME_ENV"
      value = data.aws_secretsmanager_secret_version.docker_hub_username.secret_string
    }

    environment_variable {
      name  = "GW_USER"
      value = data.aws_secretsmanager_secret_version.gw_user.secret_string
    }

    environment_variable {
      name  = "GW_PASS"
      value = data.aws_secretsmanager_secret_version.gw_pass.secret_string
    }

    environment_variable {
      name  = "GW_2FA_SECRET"
      value = data.aws_secretsmanager_secret_version.gw_2fa_secret.secret_string
    }

    environment_variable {
      name  = "GOOGLE_API_CREDENTIALS"
      value = data.aws_secretsmanager_secret_version.google_api_credentials.secret_string
    }

    environment_variable {
      name  = "GOOGLE_API_TOKEN_DATA"
      value = data.aws_secretsmanager_secret_version.google_api_token_data.secret_string
    }

    environment_variable {
      name  = "RADIUS_KEY"
      value = data.aws_secretsmanager_secret_version.radius_key.secret_string
    }

    environment_variable {
      name  = "RADIUS_IPS"
      value = data.aws_secretsmanager_secret_version.radius_ips.secret_string
    }

    environment_variable {
      name  = "SUBDOMAIN"
      value = var.env_subdomain
    }

    environment_variable {
      name  = "GOVWIFI_PHONE_NUMBER"
      value = var.govwifi_phone_number
    }

    environment_variable {
      name  = "NOTIFY_GO_TEMPLATE_ID"
      value = local.notify_go_template_id
    }

    environment_variable {
      name  = "NOTIFY_SMOKETEST_API_KEY"
      value = data.aws_secretsmanager_secret_version.notify_smoketest_api_key.secret_string
    }

    environment_variable {
      name  = "SESSION_DB_PASSWORD"
      value = jsondecode(data.aws_secretsmanager_secret_version.session_db.secret_string)["password"]
    }

    environment_variable {
      name  = "SESSION_DB_USERNAME"
      value = jsondecode(data.aws_secretsmanager_secret_version.session_db.secret_string)["username"]
    }

    environment_variable {
      name  = "SESSION_DB_NAME"
      value = "govwifi_${var.env}"
    }

    environment_variable {
      name  = "SESSION_DB_HOST"
      value = var.db_hostname
    }

    environment_variable {
      name  = "USER_DB_PASSWORD"
      value = jsondecode(data.aws_secretsmanager_secret_version.users_db.secret_string)["password"]
    }

    environment_variable {
      name  = "USER_DB_USERNAME"
      value = jsondecode(data.aws_secretsmanager_secret_version.users_db.secret_string)["username"]
    }

    environment_variable {
      name  = "USER_DB_NAME"
      value = "govwifi_${var.env}_users"
    }

    environment_variable {
      name  = "USER_DB_HOST"
      value = var.user_db_hostname
    }
  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/buildspec.yml")

  }

  vpc_config {
    vpc_id = aws_vpc.smoke_tests.id

    # IDs of the two PRIVATE subnets
    subnets = [
      "${aws_subnet.smoke_tests_private_a.id}",
      "${aws_subnet.smoke_tests_private_b.id}",
    ] #

    security_group_ids = [
      "${aws_vpc.smoke_tests.default_security_group_id}"
    ] #The default vpc security group goes here. Lets all traffic in and out (this is what all the codebuild jobs do anyway)
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "govwifi-smoke-tests-group"
      stream_name = "govwifi-smoke-tests-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.smoke_tests_bucket.id}/smoke-tests-log"
    }
  }

}

# Trigger smoke-tests every 15 minutes
resource "aws_cloudwatch_event_target" "trigger_smoke_tests" {
  rule = aws_cloudwatch_event_rule.smoke_tests_schedule_rule.name
  arn  = aws_codebuild_project.smoke_tests.id

  role_arn = aws_iam_role.govwifi_codebuild.arn
}

# Enable scheduled smoke tests in production environment only
resource "aws_cloudwatch_event_rule" "smoke_tests_schedule_rule" {
  is_enabled          = var.env == "wifi" ? true : false
  name                = "smoke-tests-scheduled-build"
  schedule_expression = "cron(0/15 * * * ? *)"
}
