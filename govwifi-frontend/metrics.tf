resource "aws_cloudwatch_log_metric_filter" "auth_shared_secret_incorrect" {
  name = "${var.Env-Name}-auth-shared-secret-incorrect"

  pattern        = "\"Shared secret is incorrect\" \"Received packet\""
  log_group_name = aws_cloudwatch_log_group.frontend_log_group.name

  metric_transformation {
    name          = "auth-shared-secret-incorrect-count"
    namespace     = local.frontend_metrics_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "accounting_shared_secret_incorrect" {
  name = "${var.Env-Name}-accounting-shared-secret-incorrect"

  pattern        = "\"Shared secret is incorrect\" \"Received Accounting-Request packet\""
  log_group_name = aws_cloudwatch_log_group.frontend_log_group.name

  metric_transformation {
    name          = "accounting-shared-secret-incorrect-count"
    namespace     = local.frontend_metrics_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "outer_and_inner_identities_same" {
  name = "${var.Env-Name}-outer-and-inner-identities-same"

  pattern        = "\"Outer and inner identities are the same\""
  log_group_name = aws_cloudwatch_log_group.frontend_log_group.name

  metric_transformation {
    name          = "outer-and-inner-identities-same-count"
    namespace     = local.frontend_metrics_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "unknown_client" {
  name = "${var.Env-Name}-unknown-client"

  pattern        = "\"unknown client\""
  log_group_name = aws_cloudwatch_log_group.frontend_log_group.name

  metric_transformation {
    name          = "unknown-client"
    namespace     = local.frontend_metrics_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "radius_cannot_connect_to_api" {
  name = "${var.Env-Name}-radius-cannot-connect-to-api"

  pattern        = "\"ERROR: Server returned no data\""
  log_group_name = aws_cloudwatch_log_group.frontend_log_group.name

  metric_transformation {
    name          = "radius-cannot-connect-to-api"
    namespace     = local.frontend_metrics_namespace
    value         = "1"
    default_value = "0"
  }
}

