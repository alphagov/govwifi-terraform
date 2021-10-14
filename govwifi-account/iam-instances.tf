resource "aws_iam_instance_profile" "Dublin_ecs_instance_profile_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-instance-profile-staging"
  path  = "/"
  role  = "Dublin-ecs-instance-role-staging"
}

resource "aws_iam_instance_profile" "Dublin_ecs_instance_profile_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-instance-profile-wifi"
  path  = "/"
  role  = "Dublin-ecs-instance-role-wifi"
}

resource "aws_iam_instance_profile" "Dublin_frontend_ecs_instance_profile_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-instance-profile-staging"
  path  = "/"
  role  = "Dublin-frontend-ecs-instance-role-staging"
}

resource "aws_iam_instance_profile" "Dublin_frontend_ecs_instance_profile_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-instance-profile-wifi"
  path  = "/"
  role  = "Dublin-frontend-ecs-instance-role-wifi"
}

resource "aws_iam_instance_profile" "Dublin_wifi_backend_bastion_instance_profile" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-wifi-backend-bastion-instance-profile"
  path  = "/"
  role  = "Dublin-wifi-backend-bastion-instance-role"
}

resource "aws_iam_instance_profile" "GDSAdminAccessGovWifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "GDSAdminAccessGovWifi"
  path  = "/"
  role  = "GDSAdminAccessGovWifi"
}

resource "aws_iam_instance_profile" "London_ecs_instance_profile_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-instance-profile-staging"
  path  = "/"
  role  = "London-ecs-instance-role-staging"
}

resource "aws_iam_instance_profile" "London_ecs_instance_profile_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-instance-profile-wifi"
  path  = "/"
  role  = "London-ecs-instance-role-wifi"
}

resource "aws_iam_instance_profile" "London_frontend_ecs_instance_profile_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-instance-profile-staging"
  path  = "/"
  role  = "London-frontend-ecs-instance-role-staging"
}

resource "aws_iam_instance_profile" "London_frontend_ecs_instance_profile_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-instance-profile-wifi"
  path  = "/"
  role  = "London-frontend-ecs-instance-role-wifi"
}

resource "aws_iam_instance_profile" "London_staging_backend_bastion_instance_profile" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-staging-backend-bastion-instance-profile"
  path  = "/"
  role  = "London-staging-backend-bastion-instance-role"
}

resource "aws_iam_instance_profile" "London_wifi_backend_bastion_instance_profile" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-wifi-backend-bastion-instance-profile"
  path  = "/"
  role  = "London-wifi-backend-bastion-instance-role"
}
