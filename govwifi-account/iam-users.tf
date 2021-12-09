resource "aws_iam_user" "govwifi_pipeline_deploy_prod" {
  name          = "govwifi-pipeline-deploy-prod"
  path          = "/"
  force_destroy = false
}

resource "aws_iam_user" "govwifi_pipeline_deploy_admin" {
  name          = "govwifi-pipeline-deploy-admin"
  path          = "/"
  force_destroy = false
}

resource "aws_iam_user" "govwifi_pipeline_deploy_smoketest" {
  name          = "govwifi-pipeline-deploy-smoketest"
  path          = "/"
  force_destroy = false
}

resource "aws_iam_user" "govwifi_pipeline_terraform" {
  name          = "govwifi-pipeline-terraform"
  path          = "/"
  force_destroy = false
}

# Groups for the users

resource "aws_iam_user_group_membership" "govwifi_pipeline_terraform" {
  user = "govwifi-pipeline-terraform"

  groups = [
    "AWS-Admin",
  ]
}

resource "aws_iam_user_group_membership" "govwifi_pipeline_deploy_prod" {
  user = "govwifi-pipeline-deploy-prod"

  groups = [
    "GovWifi-Pipeline",
  ]
}

resource "aws_iam_user_group_membership" "govwifi_pipeline_deploy_smoketest" {
  user = "govwifi-pipeline-deploy-smoketest"

  groups = [
    "GovWifi-Pipeline",
  ]
}

resource "aws_iam_user_group_membership" "govwifi_pipeline_deploy_admin" {
  user = "govwifi-pipeline-deploy-admin"

  groups = [
    "GovWifi-Pipeline",
  ]
}

resource "aws_iam_user" "monitoring_stats_user" {
  name          = "monitoring-stats-user"
  path          = "/"
  force_destroy = false
}

# User policy attachments

resource "aws_iam_user_policy_attachment" "deploy_smoketest_container_service_events_role" {
  user       = aws_iam_user.govwifi_pipeline_deploy_smoketest.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_user_policy_attachment" "deploy_smoketest_ec2_container_registry_power_user" {
  user       = aws_iam_user.govwifi_pipeline_deploy_smoketest.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_user_policy_attachment" "deploy_smoketest_read_wordlist" {
  user       = aws_iam_user.govwifi_pipeline_deploy_smoketest.name
  policy_arn = "arn:aws:iam::${var.aws_account_id}:policy/read-wordlist-policy"
}
