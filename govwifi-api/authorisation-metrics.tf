resource "aws_cloudwatch_log_metric_filter" "response-status-ok" {
  count = "${aws_cloudwatch_log_group.authorisation-api-log-group.count}"
  name  = "${var.Env-Name}-response-status-ok"

  pattern        = "\"status=200\" -\"user/HEALTH\""
  log_group_name = "${aws_cloudwatch_log_group.authorisation-api-log-group.name}"

  metric_transformation {
    name          = "${var.Env-Name}-response-status-ok-count"
    namespace     = "${local.authorisation_api_namespace}"
    value         = "1"
    default_value = "0"
  }
}
