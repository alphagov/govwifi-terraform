resource "aws_cloudwatch_log_metric_filter" "response_status_ok" {
  count = 1
  name  = "${var.env_name}-response-status-ok"

  pattern        = "\"status=200\" -\"user/HEALTH\""
  log_group_name = aws_cloudwatch_log_group.authorisation_api_log_group.name

  metric_transformation {
    name          = "${var.env_name}-response-status-ok-count"
    namespace     = local.authorisation_api_namespace
    value         = "1"
    default_value = "0"
  }
}

