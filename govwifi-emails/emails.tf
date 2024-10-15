resource "aws_ses_receipt_rule_set" "main" {
  rule_set_name = "GovWifiRuleSet"
}

resource "aws_ses_receipt_rule" "user_signup_rule" {
  name          = "${var.env_name}-user-signup-rule"
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
  enabled       = true
  scan_enabled  = true

  depends_on = [
    aws_sns_topic.user_signup_notifications,
    aws_s3_bucket.emailbucket
  ]

  recipients = [
    "enrol@${var.env_subdomain}.service.gov.uk",
    "enroll@${var.env_subdomain}.service.gov.uk",
    "signup@${var.env_subdomain}.service.gov.uk",
    "sponsor@${var.env_subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.env_name}-emailbucket"
    topic_arn   = aws_sns_topic.user_signup_notifications.arn
    position    = 1
  }

  stop_action {
    position = 2
    scope    = "RuleSet"
  }
}

resource "aws_ses_receipt_rule" "all_mail_rule" {
  name          = "${var.env_name}-all-mail-rule"
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
  enabled       = true
  scan_enabled  = true
  after         = "${var.env_name}-user-signup-rule"

  depends_on = [
    aws_sns_topic.govwifi_email_notifications,
    aws_s3_bucket.emailbucket,
    aws_ses_receipt_rule.user_signup_rule,
  ]

  recipients = [
    "verify@${var.env_subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.env_name}-emailbucket"
    topic_arn   = aws_sns_topic.govwifi_email_notifications.arn
    position    = 1
  }
}

resource "aws_ses_receipt_rule" "admin_email_rule" {
  name          = "${var.env_name}-admin-email-rule"
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
  enabled       = true
  scan_enabled  = true
  after         = aws_ses_receipt_rule.all_mail_rule.name

  depends_on = [
    aws_s3_bucket.admin_emailbucket,
    aws_ses_receipt_rule.all_mail_rule,
  ]

  recipients = [
    "admin@${var.env_subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.env_name}-admin-emailbucket"
    position    = 1
  }
}

resource "aws_ses_receipt_rule" "log_request_rule" {
  name          = "${var.env_name}-log-request-rule"
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
  enabled       = true
  scan_enabled  = true
  after         = aws_ses_receipt_rule.all_mail_rule.name

  recipients = [
    "logrequest@${var.env_subdomain}.service.gov.uk",
  ]

  sns_action {
    topic_arn = var.devops_notifications_arn
    position  = 1
  }
}

