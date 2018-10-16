resource "aws_cloudwatch_event_rule" "daily_statistics_logging_event" {
  name                = "${var.Env-Name}-daily-statistics-frequency"
  description         = "Triggers daily 0625 UTC"
  schedule_expression = "cron(15 4 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "daily_statistics_user_signup_event" {
  name                = "${var.Env-Name}-daily-statistics-frequency"
  description         = "Triggers daily 0625 UTC"
  schedule_expression = "cron(45 4 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "weekly_statistics_logging_event" {
  name                = "${var.Env-Name}-weekly-statistics-frequency"
  description         = "Triggers every SUN 0647 UTC"
  schedule_expression = "cron(15 5 ? * 7 *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "weekly_statistics_user_signup_event" {
  name                = "${var.Env-Name}-weekly-statistics-frequency"
  description         = "Triggers every SUN 0647 UTC"
  schedule_expression = "cron(45 5 ? * 7 *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "monthly_statistics_logging_event" {
  name                = "${var.Env-Name}-monthly-statistics-frequency"
  description         = "Triggers on the first of each month at 0652 UTC"
  schedule_expression = "cron(0 6 1 * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "monthly_statistics_user_signup_event" {
  name                = "${var.Env-Name}-monthly-statistics-frequency"
  description         = "Triggers on the first of each month at 0652 UTC"
  schedule_expression = "cron(30 6 1 * ? *)"
  is_enabled          = true
}
