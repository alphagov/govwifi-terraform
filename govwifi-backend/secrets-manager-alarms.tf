#
resource "aws_cloudwatch_event_rule" "secretmanager_putsecretvalue_rule" {
  count       = 1
  name        = "${var.env}-PutSecretValue-Alarm"
  description = "Monitor when a user creates a new version of the secret with new encrypted data."

  event_pattern = <<EOF
{
  "EventName": [ "PutSecretValue" ]
}
EOF

}

resource "aws_cloudwatch_event_target" "secretmanager_putsecretvalue_sns" {
  rule      = aws_cloudwatch_event_rule.secretmanager_putsecretvalue_rule[0].name
  target_id = "SendToSNS"
  arn       = var.critical-notifications-arn
}
