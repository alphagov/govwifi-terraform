resource "aws_iam_group_policy_attachment" "GovWifi_Audit_policy_attachment_GovWifi_Audit" {
  group      = "GovWifi-Audit"
  policy_arn = "arn:aws:iam::${var.aws_account_id}:policy/GovWifi-Audit"
}

resource "aws_iam_group_policy_attachment" "LambdaUpdateFunctionCode_policy_attachment_GovWifi_Pipeline" {
  group      = "GovWifi-Pipeline"
  policy_arn = "arn:aws:iam::${var.aws_account_id}:policy/LambdaUpdateFunctionCode"
}

resource "aws_iam_group_policy_attachment" "can_restart_ecs_services_GovWifi_Pipeline" {
  group      = "GovWifi-Pipeline"
  policy_arn = "arn:aws:iam::${var.aws_account_id}:policy/can-restart-ecs-services"
}
