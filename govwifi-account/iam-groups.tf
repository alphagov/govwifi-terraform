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

resource "aws_iam_group" "GovWifi-Pipeline" {
  name = "GovWifi-Pipeline"
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

