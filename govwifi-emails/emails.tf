resource "aws_ses_receipt_rule" "user-signup-rule" {
  name          = "${var.Env-Name}-user-signup-rule"
  rule_set_name = "GovWifiRuleSet"
  enabled       = true
  scan_enabled  = true

  depends_on = [
    aws_sns_topic.user-signup-notifications,
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
    topic_arn   = aws_sns_topic.user-signup-notifications.arn
    position    = 1
  }

  stop_action {
    position = 2
    scope    = "RuleSet"
  }
}

resource "aws_ses_receipt_rule" "all-mail-rule" {
  name          = "${var.Env-Name}-all-mail-rule"
  rule_set_name = "GovWifiRuleSet"
  enabled       = true
  scan_enabled  = true
  after         = "${var.Env-Name}-user-signup-rule"

  depends_on = [
    aws_sns_topic.govwifi-email-notifications,
    aws_s3_bucket.emailbucket,
    aws_ses_receipt_rule.user-signup-rule,
  ]

  recipients = [
    "verify@${var.Env-Subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.Env-Name}-emailbucket"
    topic_arn   = aws_sns_topic.govwifi-email-notifications.arn
    position    = 1
  }
}

resource "aws_ses_receipt_rule" "newsite-mail-rule" {
  name          = "${var.Env-Name}-newsite-mail-rule"
  rule_set_name = "GovWifiRuleSet"
  enabled       = true
  scan_enabled  = true
  after         = "${var.Env-Name}-all-mail-rule"

  depends_on = [
    aws_sns_topic.govwifi-email-notifications,
    aws_s3_bucket.emailbucket,
    aws_ses_receipt_rule.user-signup-rule,
  ]

  recipients = [
    "newsite@${var.Env-Subdomain}.service.gov.uk",
  ]

  sns_action {
    topic_arn = var.devops-notifications-arn
    position  = 1
  }
}

resource "aws_ses_receipt_rule" "admin-email-rule" {
  name          = "${var.Env-Name}-admin-email-rule"
  rule_set_name = "GovWifiRuleSet"
  enabled       = true
  scan_enabled  = true
  after         = "${var.Env-Name}-newsite-mail-rule"

  depends_on = [
    aws_s3_bucket.admin-emailbucket,
    aws_ses_receipt_rule.all-mail-rule,
  ]

  recipients = [
    "admin@${var.Env-Subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.Env-Name}-admin-emailbucket"
    position    = 1
  }
}

resource "aws_ses_receipt_rule" "log-request-rule" {
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

