resource "aws_iam_group" "AWS-Admin" {
  name = "AWS-Admin"
  path = "/"
}

resource "aws_iam_group" "GDS-IT-Developers" {
  name = "GDS-IT-Developers"
  path = "/"
}

resource "aws_iam_group" "GDS-IT-Networks" {
  name = "GDS-IT-Networks"
  path = "/"
}

resource "aws_iam_group" "GovWifi-Admin" {
  name = "GovWifi-Admin"
  path = "/"
}

resource "aws_iam_group" "GovWifi-Audit" {
  name = "GovWifi-Audit"
  path = "/"
}

resource "aws_iam_group" "GovWifi-Developers" {
  name = "GovWifi-Developers"
  path = "/"
}

resource "aws_iam_group" "GovWifi-Support" {
  name = "GovWifi-Support"
  path = "/"
}

resource "aws_iam_group" "ITHC-RO-SecAud-Group" {
  name = "ITHC-RO-SecAud-Group"
  path = "/"
}

resource "aws_iam_group" "Read-Only-Access" {
  name = "Read-Only-Access"
  path = "/"
}

resource "aws_iam_group_membership" "AWS-Admin" {
  name  = "AWS-Admin-group-membership"
  users = ["govwifi-jenkins-terraform"]
  group = "AWS-Admin"
}

resource "aws_iam_group_membership" "GDS-IT-Developers" {
  name  = "GDS-IT-Developers-group-membership"
  users = []
  group = "GDS-IT-Developers"
}

resource "aws_iam_group_membership" "GDS-IT-Networks" {
  name  = "GDS-IT-Networks-group-membership"
  users = []
  group = "GDS-IT-Networks"
}

resource "aws_iam_group_membership" "GovWifi-Admin" {
  name  = "GovWifi-Admin-group-membership"
  users = []
  group = "GovWifi-Admin"
}

resource "aws_iam_group_membership" "GovWifi-Audit" {
  name  = "GovWifi-Audit-group-membership"
  users = []
  group = "GovWifi-Audit"
}

resource "aws_iam_group_membership" "GovWifi-Developers" {
  name  = "GovWifi-Developers-group-membership"
  users = []
  group = "GovWifi-Developers"
}

resource "aws_iam_group_membership" "GovWifi-Support" {
  name  = "GovWifi-Support-group-membership"
  users = []
  group = "GovWifi-Support"
}

resource "aws_iam_group_membership" "ITHC-RO-SecAud-Group" {
  name  = "ITHC-RO-SecAud-Group-group-membership"
  users = []
  group = "ITHC-RO-SecAud-Group"
}

resource "aws_iam_group_membership" "Read-Only-Access" {
  name  = "Read-Only-Access-group-membership"
  users = ["monitor", "servicedesk"]
  group = "Read-Only-Access"
}
