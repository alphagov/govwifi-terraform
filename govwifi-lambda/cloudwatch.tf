resource "aws_cloudwatch_event_rule" "every_day_at_midnight" {
  name                = "every-day-at-midnight"
  description         = "Triggers every morning at Midnight"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "delete_users_every_day_at_midnight" {
  rule      = "${aws_cloudwatch_event_rule.every_day_at_midnight.name}"
  target_id = "user_deletion"
  arn       = "${aws_lambda_function.user_deletion.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_delete_users" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.user_deletion.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_day_at_midnight.arn}"
}

resource "aws_cloudwatch_event_rule" "every_day_at_ten_past_midnight" {
  name                = "every-day-at-ten-past-midnight"
  description         = "Triggers every morning at 10 past midnight"
  schedule_expression = "cron(10 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "delete_sessions_every_day_at_ten_past_midnight" {
  rule      = "${aws_cloudwatch_event_rule.every_day_at_ten_past_midnight.name}"
  target_id = "session_deletion"
  arn       = "${aws_lambda_function.session_deletion.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_delete_sessions" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.session_deletion.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_day_at_ten_past_midnight.arn}"
}
