resource "aws_iam_group" "AWS_Admin" {
  name = "AWS-Admin"
  path = "/"
}

resource "aws_iam_group" "GDS_IT_Developers" {
  name = "GDS-IT-Developers"
  path = "/"
}

resource "aws_iam_group" "GDS_IT_Networks" {
  name = "GDS-IT-Networks"
  path = "/"
}

resource "aws_iam_group" "GovWifi_Admin" {
  name = "GovWifi-Admin"
  path = "/"
}

resource "aws_iam_group" "GovWifi_Audit" {
  name = "GovWifi-Audit"
  path = "/"
}

resource "aws_iam_group" "GovWifi_Developers" {
  name = "GovWifi-Developers"
  path = "/"
}

resource "aws_iam_group" "GovWifi_Support" {
  name = "GovWifi-Support"
  path = "/"
}

resource "aws_iam_group" "GovWifi_Pipeline" {
  name = "GovWifi-Pipeline"
  path = "/"
}

resource "aws_iam_group" "ITHC_RO_SecAud_Group" {
  name = "ITHC-RO-SecAud-Group"
  path = "/"
}

resource "aws_iam_group" "Read_Only_Access" {
  name = "Read-Only-Access"
  path = "/"
}

