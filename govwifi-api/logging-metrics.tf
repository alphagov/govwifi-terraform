resource "aws_cloudwatch_log_metric_filter" "radius-access-reject" {
  count          = "${aws_cloudwatch_log_group.logging-api-log-group.count}"
  name           = "${var.Env-Name}-radius-access-reject"
  pattern        = "\"\\\"authentication_result\\\": \\\"Access-Reject\\\"\""
  log_group_name = "${aws_cloudwatch_log_group.logging-api-log-group.name}"

  metric_transformation {
    name          = "${var.Env-Name}-radius-access-reject-count"
    namespace     = "${local.logging_api_namespace}"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "radius-access-accept" {
  count = "${aws_cloudwatch_log_group.logging-api-log-group.count}"
  name  = "${var.Env-Name}-radius-access-accept"

  # match all accepts, but not the healthchecks
  pattern        = "\"\\\"authentication_result\\\": \\\"Access-Accept\\\"\" -\"\\\"username\\\": \\\"HEALTH\\\"\""
  log_group_name = "${aws_cloudwatch_log_group.logging-api-log-group.name}"

  metric_transformation {
    name          = "${var.Env-Name}-radius-access-accept-count"
    namespace     = "${local.logging_api_namespace}"
    value         = "1"
    default_value = "0"
  }
}
