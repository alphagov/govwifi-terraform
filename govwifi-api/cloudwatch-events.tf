resource "aws_cloudwatch_event_rule" "daily_statistics_logging_event" {
  count               = "${var.event-rule-count}"
  name                = "${var.Env-Name}-daily-statistics-frequency-logging"
  description         = "Triggers daily 04:15 am UTC"
  schedule_expression = "cron(15 4 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "daily_statistics_user_signup_event" {
  count               = "${var.event-rule-count}"
  name                = "${var.Env-Name}-daily-statistics-frequency-user-signup"
  description         = "Triggers daily 04:45 am UTC"
  schedule_expression = "cron(45 4 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "weekly_statistics_logging_event" {
  count               = "${var.event-rule-count}"
  name                = "${var.Env-Name}-weekly-statistics-frequency-logging"
  description         = "Triggers every SUN 05:15 am UTC"
  schedule_expression = "cron(15 5 ? * 7 *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "weekly_statistics_user_signup_event" {
  count               = "${var.event-rule-count}"
  name                = "${var.Env-Name}-weekly-statistics-frequency-user-signup"
  description         = "Triggers every SUN 05:45 am UTC"
  schedule_expression = "cron(45 5 ? * 7 *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "monthly_statistics_logging_event" {
  count               = "${var.event-rule-count}"
  name                = "${var.Env-Name}-monthly-statistics-frequency-logging"
  description         = "Triggers on the first of each month at 06:00 am UTC"
  schedule_expression = "cron(0 6 1 * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "monthly_statistics_user_signup_event" {
  count               = "${var.event-rule-count}"
  name                = "${var.Env-Name}-monthly-statistics-frequency-user-signup"
  description         = "Triggers on the first of each month at 06:30 am UTC"
  schedule_expression = "cron(30 6 1 * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "daily_session_deletion_event" {
  count               = "${var.event-rule-count}"
  name                = "${var.Env-Name}-daily-session-deletion"
  description         = "Triggers daily 22:00 pm UTC"
  schedule_expression = "cron(0 22 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_rule" "daily_user_deletion_event" {
  count               = "${var.event-rule-count}"
  name                = "${var.Env-Name}-daily-user-deletion"
  description         = "Triggers daily 23:00 pm UTC"
  schedule_expression = "cron(0 23 * * ? *)"
  is_enabled          = true
}
