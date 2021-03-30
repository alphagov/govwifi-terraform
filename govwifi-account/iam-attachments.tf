resource "aws_iam_group_policy_attachment" "GovWifi-Audit-policy-attachment_GovWifi-Audit" {
  group      = "GovWifi-Audit"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/GovWifi-Audit"
}

resource "aws_iam_group_policy_attachment" "LambdaUpdateFunctionCode-policy-attachment_GovWifi-Pipeline" {
  group      = "GovWifi-Pipeline"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/LambdaUpdateFunctionCode"
}

resource "aws_iam_group_policy_attachment" "AmazonEC2ContainerServiceEventsRole-policy-attachment_GovWifi-Pipeline" {
  group      = "GovWifi-Pipeline"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_group_policy_attachment" "AmazonEC2ContainerRegistryPowerUser-policy-attachment_GovWifi-Pipeline" {
  group      = "GovWifi-Pipeline"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_group_policy_attachment" "read-wordlist-policy_GovWifi-Pipeline" {
  group      = "GovWifi-Pipeline"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/read-wordlist-policy"
}

resource "aws_iam_group_policy_attachment" "can-restart-ecs-services_GovWifi-Pipeline" {
  group      = "GovWifi-Pipeline"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/can-restart-ecs-services"
}

