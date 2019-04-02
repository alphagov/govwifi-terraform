resource "aws_cloudwatch_log_metric_filter" "auth-shared-secret-incorrect" {
  name = "${var.Env-Name}-auth-shared-secret-incorrect"

  pattern        = "\"Shared secret is incorrect\" \"Received packet\""
  log_group_name = "${aws_cloudwatch_log_group.frontend-log-group.name}"

  metric_transformation {
    name          = "auth-shared-secret-incorrect-count"
    namespace     = "${local.frontend_metrics_namespace}"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "accounting-shared-secret-incorrect" {
  name = "${var.Env-Name}-accounting-shared-secret-incorrect"

  pattern        = "\"Shared secret is incorrect\" \"Received Accounting-Request packet\""
  log_group_name = "${aws_cloudwatch_log_group.frontend-log-group.name}"

  metric_transformation {
    name          = "accounting-shared-secret-incorrect-count"
    namespace     = "${local.frontend_metrics_namespace}"
    value         = "1"
    default_value = "0"
  }
}
