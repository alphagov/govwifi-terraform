resource "aws_ses_receipt_rule" "user_signup_rule" {
  name          = "${var.Env-Name}-user-signup-rule"
  rule_set_name = "GovWifiRuleSet"
  enabled       = true
  scan_enabled  = true

  depends_on = [
    aws_sns_topic.user_signup_notifications,
    aws_s3_bucket.emailbucket
  ]

  recipients = [
    "enrol@${var.Env-Subdomain}.service.gov.uk",
    "enroll@${var.Env-Subdomain}.service.gov.uk",
    "signup@${var.Env-Subdomain}.service.gov.uk",
    "sponsor@${var.Env-Subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.Env-Name}-emailbucket"
    topic_arn   = aws_sns_topic.user_signup_notifications.arn
    position    = 1
  }

  stop_action {
    position = 2
    scope    = "RuleSet"
  }
}

resource "aws_ses_receipt_rule" "all_mail_rule" {
  name          = "${var.Env-Name}-all-mail-rule"
  rule_set_name = "GovWifiRuleSet"
  enabled       = true
  scan_enabled  = true
  after         = "${var.Env-Name}-user-signup-rule"

  depends_on = [
    aws_sns_topic.govwifi_email_notifications,
    aws_s3_bucket.emailbucket,
    aws_ses_receipt_rule.user_signup_rule,
  ]

  recipients = [
    "verify@${var.Env-Subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.Env-Name}-emailbucket"
    topic_arn   = aws_sns_topic.govwifi_email_notifications.arn
    position    = 1
  }
}

resource "aws_ses_receipt_rule" "newsite_mail_rule" {
  name          = "${var.Env-Name}-newsite-mail-rule"
  rule_set_name = "GovWifiRuleSet"
  enabled       = true
  scan_enabled  = true
  after         = "${var.Env-Name}-all-mail-rule"

  depends_on = [
    aws_sns_topic.govwifi_email_notifications,
    aws_s3_bucket.emailbucket,
    aws_ses_receipt_rule.user_signup_rule,
  ]

  recipients = [
    "newsite@${var.Env-Subdomain}.service.gov.uk",
  ]

  sns_action {
    topic_arn = var.devops-notifications-arn
    position  = 1
  }
}

resource "aws_ses_receipt_rule" "admin_email_rule" {
  name          = "${var.Env-Name}-admin-email-rule"
  rule_set_name = "GovWifiRuleSet"
  enabled       = true
  scan_enabled  = true
  after         = "${var.Env-Name}-newsite-mail-rule"

  depends_on = [
    aws_s3_bucket.admin_emailbucket,
    aws_ses_receipt_rule.all_mail_rule,
  ]

  recipients = [
    "admin@${var.Env-Subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.Env-Name}-admin-emailbucket"
    position    = 1
  }
}

resource "aws_ses_receipt_rule" "log_request_rule" {
  name          = "${var.Env-Name}-log-request-rule"
  rule_set_name = "GovWifiRuleSet"
  enabled       = true
  scan_enabled  = true
  after         = "${var.Env-Name}-admin-email-rule"

  recipients = [
    "logrequest@${var.Env-Subdomain}.service.gov.uk",
  ]

  sns_action {
    topic_arn = var.devops-notifications-arn
    position  = 1
  }
}

