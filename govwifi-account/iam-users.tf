# Current users

resource "aws_iam_user" "monitor" {
  name = "monitor"
  path = "/"
}

### Users to be changed

# Old user to rename and split into 3 - will retire once no longer in use and below 3 are
resource "aws_iam_user" "govwifi-jenkins-deploy" {
  name          = "govwifi-jenkins-deploy"
  path          = "/"
  force_destroy = false
}

# New User from above for prod
resource "aws_iam_user" "govwifi-pipeline-deploy-prod" {
  name          = "govwifi-pipeline-deploy-prod"
  path          = "/"
  force_destroy = false
}

# New User from above for admin 
resource "aws_iam_user" "govwifi-pipeline-deploy-admin" {
  name          = "govwifi-pipeline-deploy-admin"
  path          = "/"
  force_destroy = false
}

# New User from above for staging
resource "aws_iam_user" "govwifi-pipeline-deploy-staging" {
  name          = "govwifi-pipeline-deploy-staging"
  path          = "/"
  force_destroy = false
}

# New User from above for smoketest
resource "aws_iam_user" "govwifi-pipeline-deploy-smoketest" {
  name          = "govwifi-pipeline-deploy-smoketest"
  path          = "/"
  force_destroy = false
}

# Old username - rename from jenkins to pipeline to make agnostic
resource "aws_iam_user" "govwifi-jenkins-terraform" {
  name          = "govwifi-jenkins-terraform"
  path          = "/"
  force_destroy = false
}

# New replacement
resource "aws_iam_user" "govwifi-pipeline-terraform" {
  name          = "govwifi-pipeline-terraform"
  path          = "/"
  force_destroy = false
}

### Users no longer needed?

# Not used currently? Deactivated and awaiting screaming before re-activating
resource "aws_iam_user" "jenkins-read-wordlist-user" {
  name          = "jenkins-read-wordlist-user"
  path          = "/"
  force_destroy = false
}

resource "aws_iam_user" "servicedesk" {
  name          = "servicedesk"
  path          = "/"
  force_destroy = false
}

resource "aws_iam_user" "dashboard-staging-read-only-user" {
  name          = "dashboard-staging-read-only-user"
  path          = "/"
  force_destroy = false
}

resource "aws_iam_user" "dashboard-wifi-read-only-user" {
  name          = "dashboard-wifi-read-only-user"
  path          = "/"
  force_destroy = false
}

# Groups for the users

resource "aws_iam_user_group_membership" "govwifi-jenkins-terraform" {
  user = "govwifi-jenkins-terraform"

  groups = [
    "AWS-Admin",
  ]
}

resource "aws_iam_user_group_membership" "govwifi-pipeline-terraform" {
  user = "govwifi-pipeline-terraform"

  groups = [
    "AWS-Admin",
  ]
}

resource "aws_iam_user_group_membership" "govwifi-pipeline-deploy-prod" {
  user = "govwifi-pipeline-deploy-prod"

  groups = [
    "GovWifi-Pipeline",
  ]
}

resource "aws_iam_user_group_membership" "govwifi-pipeline-deploy-staging" {
  user = "govwifi-pipeline-deploy-staging"

  groups = [
    "GovWifi-Pipeline",
  ]
}

resource "aws_iam_user_group_membership" "govwifi-pipeline-deploy-smoketest" {
  user = "govwifi-pipeline-deploy-smoketest"

  groups = [
    "GovWifi-Pipeline",
  ]
}

resource "aws_iam_user_group_membership" "govwifi-pipeline-deploy-admin" {
  user = "govwifi-pipeline-deploy-admin"

  groups = [
    "GovWifi-Pipeline",
  ]
}

resource "aws_iam_user_group_membership" "monitor" {
  user = "monitor"

  groups = [
    "Read-Only-Access",
  ]
}

resource "aws_iam_user_group_membership" "servicedesk" {
  user = "servicedesk"

  groups = [
    "Read-Only-Access",
  ]
}

