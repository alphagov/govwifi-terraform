resource "aws_iam_group_policy_attachment" "GovWifi_Audit_policy_attachment_GovWifi_Audit" {
  group      = "GovWifi-Audit"
  policy_arn = "arn:aws:iam::${var.aws_account_id}:policy/GovWifi-Audit"
}
