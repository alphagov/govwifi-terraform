resource "aws_cloudwatch_event_rule" "every_day_at_midnight" {
  name                = "every-day-at-midnight-${var.Env-Name}-${lower(var.aws-region-name)}"
  description         = "Triggers every morning at Midnight UTC"
  schedule_expression = "cron(0 0 * * ? *)"
  is_enabled          = "${var.enable-user-del-cron}"
}

resource "aws_cloudwatch_event_target" "delete_users_every_day_at_midnight" {
  rule      = "${aws_cloudwatch_event_rule.every_day_at_midnight.name}"
  target_id = "user_deletion_${var.Env-Name}-${lower(var.aws-region-name)}"
  arn       = "${aws_lambda_function.user_deletion.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_delete_users" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.user_deletion.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_day_at_midnight.arn}"
}


resource "aws_cloudwatch_event_rule" "delete_sessions_frequency" {
  name                = "delete-sessions-frequency-${var.Env-Name}-${lower(var.aws-region-name)}"
  description         = "Triggers every 5 minutes between 2200-2300 UTC"
  schedule_expression = "cron(0/5 22-23 * * ? *)"
  is_enabled          = "${var.enable-session-del-cron}"
}

resource "aws_cloudwatch_event_target" "delete_sessions_every_day" {
  rule      = "${aws_cloudwatch_event_rule.delete_sessions_frequency.name}"
  target_id = "session_deletion_${var.Env-Name}-${lower(var.aws-region-name)}"
  arn       = "${aws_lambda_function.session_deletion.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_delete_sessions" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.session_deletion.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.delete_sessions_frequency.arn}"
}
