resource "aws_cloudwatch_event_rule" "daily_statistics_event" {
  name                = "${var.Env-Name}-daily-statistics-frequency"
  description         = "Triggers daily 0625 UTC"
  schedule_expression = "cron(25 6 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "weekly_statistics_event" {
  name                = "${var.Env-Name}-weekly-statistics-frequency"
  description         = "Triggers every SUN 0647 UTC"
  schedule_expression = "cron(47 6 ? * 7 *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "monthly_statistics_event" {
  name                = "${var.Env-Name}-monthly-statistics-frequency"
  description         = "Triggers on the first of each month at 0652 UTC"
  schedule_expression = "cron(52 6 1 * ? *)"
  is_enabled          = true
}
