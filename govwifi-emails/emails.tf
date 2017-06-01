# SES setup to receive emails - there should be a DNS MX entry for
# the amazon mail server in the region used.
resource "aws_ses_receipt_rule_set" "main-ses-ruleset" {
  rule_set_name = "${var.Env-Name}-ses-ruleset"
}

resource "aws_ses_receipt_rule" "incoming-ses-rule" {
  name          = "${var.Env-Name}-incoming-ses-rule"
  rule_set_name = "${var.Env-Name}-ses-ruleset"
  enabled       = true
  scan_enabled  = true

  depends_on = [
    "aws_ses_receipt_rule_set.main-ses-ruleset",
    "aws_sns_topic.govwifi-email-notifications",
    "aws_s3_bucket.emailbucket",
  ]

  recipients = [
    "enrol@${var.Env-Name}${var.Env-Subdomain}.service.gov.uk",
    "enroll@${var.Env-Name}${var.Env-Subdomain}.service.gov.uk",
    "signup@${var.Env-Name}${var.Env-Subdomain}.service.gov.uk",
    "newsite@${var.Env-Name}${var.Env-Subdomain}.service.gov.uk",
    "logrequest@${var.Env-Name}${var.Env-Subdomain}.service.gov.uk",
    "sponsor@${var.Env-Name}${var.Env-Subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.Env-Name}-emailbucket"
    topic_arn   = "${aws_sns_topic.govwifi-email-notifications.arn}"
    position    = 1
  }
}

resource "aws_ses_receipt_rule" "admin-ses-rule" {
  name          = "${var.Env-Name}-admin-ses-rule"
  rule_set_name = "${var.Env-Name}-ses-ruleset"
  enabled       = true
  scan_enabled  = true
  depends_on    = ["aws_s3_bucket.admin-emailbucket"]

  recipients = [
    "admin@${var.Env-Name}${var.Env-Subdomain}.service.gov.uk",
  ]

  s3_action {
    bucket_name = "${var.Env-Name}-admin-emailbucket"
    position    = 1
  }
}
