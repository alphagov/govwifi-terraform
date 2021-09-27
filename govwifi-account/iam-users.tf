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

resource "aws_iam_user" "govwifi_pipeline_deploy_staging" {
  name          = "govwifi-pipeline-deploy-staging"
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

resource "aws_iam_user_group_membership" "govwifi_pipeline_deploy_staging" {
  user = "govwifi-pipeline-deploy-staging"

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

resource "aws_iam_user" "it_govwifi_backup_reader" {
  name          = "it-govwifi-backup-reader"
  path          = "/"
  force_destroy = false
}
