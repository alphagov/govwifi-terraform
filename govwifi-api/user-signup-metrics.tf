resource "aws_cloudwatch_log_metric_filter" "notify_sms_successful_response" {
  count = var.user_signup_enabled
  name  = "${var.env_name}-notify-sms-success"

  pattern        = "\"user-signup/sms-notification\" \"status=200\" -\"Processing\""
  log_group_name = aws_cloudwatch_log_group.user_signup_api_log_group[0].name

  metric_transformation {
    name          = "${var.env_name}-notify-sms-success-count"
    namespace     = local.signup_api_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "notify_sms_failed_response" {
  count = var.user_signup_enabled
  name  = "${var.env_name}-notify-sms-failed"

  pattern        = "\"user-signup/sms-notification\" -\"status=200\" -\"Processing\""
  log_group_name = aws_cloudwatch_log_group.user_signup_api_log_group[0].name

  metric_transformation {
    name          = "${var.env_name}-notify-sms-failed-count"
    namespace     = local.signup_api_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "notify_email_successful_response" {
  count = var.user_signup_enabled
  name  = "${var.env_name}-notify-email-success"

  pattern        = "\"user-signup/email-notification\" \"status=200\" -\"Processing\""
  log_group_name = aws_cloudwatch_log_group.user_signup_api_log_group[0].name

  metric_transformation {
    name          = "${var.env_name}-notify-email-success-count"
    namespace     = local.signup_api_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "notify_email_failed_response" {
  count = var.user_signup_enabled
  name  = "${var.env_name}-notify-email-failed"

  pattern        = "\"user-signup/email-notification\" -\"status=200\" -\"Processing\" -\"Sending performance\""
  log_group_name = aws_cloudwatch_log_group.user_signup_api_log_group[0].name

  metric_transformation {
    name          = "${var.env_name}-notify-email-failed-count"
    namespace     = local.signup_api_namespace
    value         = "1"
    default_value = "0"
  }
}

