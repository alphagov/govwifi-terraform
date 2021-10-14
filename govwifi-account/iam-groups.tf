resource "aws_iam_group" "AWS_Admin" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "AWS-Admin"
  path  = "/"
}

resource "aws_iam_group" "GDS_IT_Developers" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "GDS-IT-Developers"
  path  = "/"
}

resource "aws_iam_group" "GDS_IT_Networks" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "GDS-IT-Networks"
  path  = "/"
}

resource "aws_iam_group" "GovWifi_Admin" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "GovWifi-Admin"
  path  = "/"
}

resource "aws_iam_group" "GovWifi_Audit" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "GovWifi-Audit"
  path  = "/"
}

resource "aws_iam_group" "GovWifi_Developers" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "GovWifi-Developers"
  path  = "/"
}

resource "aws_iam_group" "GovWifi_Support" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "GovWifi-Support"
  path  = "/"
}

resource "aws_iam_group" "GovWifi_Pipeline" {
  name = "GovWifi-Pipeline"
  path = "/"
}

resource "aws_iam_group" "ITHC_RO_SecAud_Group" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "ITHC-RO-SecAud-Group"
  path  = "/"
}

resource "aws_iam_group" "Read_Only_Access" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Read-Only-Access"
  path  = "/"
}
