#
resource "aws_cloudwatch_event_rule" "secretmanager_putsecretvalue_rule" {
  count       = 1
  name        = "${var.env}-PutSecretValue-Alarm"
  description = "This metric monitors any Secrets in SecretManager that have been written (new or update)"

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
