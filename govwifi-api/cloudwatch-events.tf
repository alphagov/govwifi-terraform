resource "aws_cloudwatch_event_rule" "daily_statistics_event" {
  name                = "${var.Env-Name}-daily-statistics-frequency"
  description         = "Triggers daily 0600 UTC"
  schedule_expression = "cron(0 6 * * ? *)"
  is_enabled          = false
}

resource "aws_cloudwatch_event_rule" "weekly_statistics_event" {
  name                = "${var.Env-Name}-weekly-statistics-frequency"
  description         = "Triggers every SUN 0630 UTC"
  schedule_expression = "cron(30 6 ? * SUN *)"
  is_enabled          = false
}
