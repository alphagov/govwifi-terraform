resource "aws_cloudwatch_event_rule" "daily_statistics_event" {
  name                = "${var.Env-Name}-daily-statistics-frequency"
  description         = "Triggers daily 0600 UTC"
  schedule_expression = "cron(47 * * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "weekly_statistics_event" {
  name                = "${var.Env-Name}-weekly-statistics-frequency"
  description         = "Triggers every SUN 0630 UTC"
  schedule_expression = "cron(47 * * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "monthly_statistics_event" {
  name                = "${var.Env-Name}-monthly-statistics-frequency"
  description         = "Triggers every SUN 0630 UTC"
  schedule_expression = "cron(47 * * * ? *)"
  is_enabled          = true
}
