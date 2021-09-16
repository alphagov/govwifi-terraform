resource "aws_cloudwatch_log_metric_filter" "radius_access_reject" {
  count          = var.logging-enabled
  name           = "${var.Env-Name}-radius-access-reject"
  pattern        = "\"\\\"authentication_result\\\": \\\"Access-Reject\\\"\""
  log_group_name = aws_cloudwatch_log_group.logging_api_log_group[0].name

  metric_transformation {
    name          = "${var.Env-Name}-radius-access-reject-count"
    namespace     = local.logging_api_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "radius_access_accept" {
  count = var.logging-enabled
  name  = "${var.Env-Name}-radius-access-accept"

  # match all accepts, but not the healthchecks
  pattern        = "\"\\\"authentication_result\\\": \\\"Access-Accept\\\"\" -\"\\\"username\\\": \\\"HEALTH\\\"\""
  log_group_name = aws_cloudwatch_log_group.logging_api_log_group[0].name

  metric_transformation {
    name          = "${var.Env-Name}-radius-access-accept-count"
    namespace     = local.logging_api_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "response_status_no_content" {
  count = var.logging-enabled
  name  = "${var.Env-Name}-response-status-no-content"

  pattern        = "\"status=204\" -\"\\\"username\\\": \\\"HEALTH\\\"\""
  log_group_name = aws_cloudwatch_log_group.logging_api_log_group[0].name

  metric_transformation {
    name          = "${var.Env-Name}-response-status-no-content-count"
    namespace     = local.logging_api_namespace
    value         = "1"
    default_value = "0"
  }
}

