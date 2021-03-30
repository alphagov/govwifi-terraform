resource "aws_cloudwatch_log_metric_filter" "notify-sms-successful-response" {
  count = length(aws_cloudwatch_log_group.user-signup-api-log-group)
  name  = "${var.Env-Name}-notify-sms-success"

  pattern        = "\"user-signup/sms-notification\" \"status=200\" -\"Processing\""
  log_group_name = aws_cloudwatch_log_group.user-signup-api-log-group[0].name

  metric_transformation {
    name          = "${var.Env-Name}-notify-sms-success-count"
    namespace     = local.signup_api_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "notify-sms-failed-response" {
  count = length(aws_cloudwatch_log_group.user-signup-api-log-group)
  name  = "${var.Env-Name}-notify-sms-failed"

  pattern        = "\"user-signup/sms-notification\" -\"status=200\" -\"Processing\""
  log_group_name = aws_cloudwatch_log_group.user-signup-api-log-group[0].name

  metric_transformation {
    name          = "${var.Env-Name}-notify-sms-failed-count"
    namespace     = local.signup_api_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "notify-email-successful-response" {
  count = length(aws_cloudwatch_log_group.user-signup-api-log-group)
  name  = "${var.Env-Name}-notify-email-success"

  pattern        = "\"user-signup/email-notification\" \"status=200\" -\"Processing\""
  log_group_name = aws_cloudwatch_log_group.user-signup-api-log-group[0].name

  metric_transformation {
    name          = "${var.Env-Name}-notify-email-success-count"
    namespace     = local.signup_api_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "notify-email-failed-response" {
  count = length(aws_cloudwatch_log_group.user-signup-api-log-group)
  name  = "${var.Env-Name}-notify-email-failed"

  pattern        = "\"user-signup/email-notification\" -\"status=200\" -\"Processing\" -\"Sending performance\""
  log_group_name = aws_cloudwatch_log_group.user-signup-api-log-group[0].name

  metric_transformation {
    name          = "${var.Env-Name}-notify-email-failed-count"
    namespace     = local.signup_api_namespace
    value         = "1"
    default_value = "0"
  }
}

