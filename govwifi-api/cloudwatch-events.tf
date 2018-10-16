resource "aws_cloudwatch_event_rule" "daily_statistics_logging_event" {
  name                = "${var.Env-Name}-daily-statistics-frequency-logging"
  description         = "Triggers daily 04:25 am UTC"
  schedule_expression = "cron(15 4 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "daily_statistics_user_signup_event" {
  name                = "${var.Env-Name}-daily-statistics-frequency-user-signup"
  description         = "Triggers daily 04:45 am UTC"
  schedule_expression = "cron(45 4 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "weekly_statistics_logging_event" {
  name                = "${var.Env-Name}-weekly-statistics-frequency-logging"
  description         = "Triggers every SUN 05:15 am UTC"
  schedule_expression = "cron(15 5 ? * 7 *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "weekly_statistics_user_signup_event" {
  name                = "${var.Env-Name}-weekly-statistics-frequency-user-signup"
  description         = "Triggers every SUN 05:45 am UTC"
  schedule_expression = "cron(45 5 ? * 7 *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "monthly_statistics_logging_event" {
  name                = "${var.Env-Name}-monthly-statistics-frequency-logging"
  description         = "Triggers on the first of each month at 06:00 am UTC"
  schedule_expression = "cron(0 6 1 * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "monthly_statistics_user_signup_event" {
  name                = "${var.Env-Name}-monthly-statistics-frequency-user-signup"
  description         = "Triggers on the first of each month at 06:30 am UTC"
  schedule_expression = "cron(30 6 1 * ? *)"
  is_enabled          = true
}
