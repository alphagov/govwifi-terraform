variable "account-id" {}
# Current users

resource "aws_iam_user" "monitor" {
  name = "monitor"
  path = "/"
}

### Users to be changed

# Old user to rename and split into 3 - will retire once no longer in use and below 3 are
resource "aws_iam_user" "govwifi-jenkins-deploy" {
  name = "govwifi-jenkins-deploy"
  path = "/"
  force_destroy = false
}

# New User from above for prod
resource "aws_iam_user" "govwifi-pipeline-deploy-prod" {
  name = "govwifi-pipeline-deploy-prod"
  path = "/"
  force_destroy = false
}

# New User from above for admin 
resource "aws_iam_user" "govwifi-pipeline-deploy-admin" {
  name = "govwifi-pipeline-deploy-admin"
  path = "/"
  force_destroy = false
}

# New User from above for staging
resource "aws_iam_user" "govwifi-pipeline-deploy-staging" {
  name = "govwifi-pipeline-deploy-staging"
  path = "/"
  force_destroy = false
}

# Old username - rename from jenkins to pipeline to make agnostic
resource "aws_iam_user" "govwifi-jenkins-terraform" {
  name = "govwifi-jenkins-terraform"
  path = "/"
  force_destroy = false
}

# New replacement
resource "aws_iam_user" "govwifi-pipeline-terraform" {
  name = "govwifi-pipeline-terraform"
  path = "/"
  force_destroy = false
}

### Users no longer needed?

# Not used currently? Deactivated and awaiting screaming before re-activating
resource "aws_iam_user" "jenkins-read-wordlist-user" {
  name = "jenkins-read-wordlist-user"
  path = "/"
  force_destroy = false
}

resource "aws_iam_user" "servicedesk" {
  name = "servicedesk"
  path = "/"
  force_destroy = false
}

resource "aws_iam_user" "dashboard-staging-read-only-user" {
  name = "dashboard-staging-read-only-user"
  path = "/"
  force_destroy = false
}

resource "aws_iam_user" "dashboard-wifi-read-only-user" {
  name = "dashboard-wifi-read-only-user"
  path = "/"
  force_destroy = false
}

