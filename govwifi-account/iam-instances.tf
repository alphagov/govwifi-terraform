resource "aws_iam_instance_profile" "Dublin-ecs-instance-profile-staging" {
  name = "Dublin-ecs-instance-profile-staging"
  path = "/"
  role = "Dublin-ecs-instance-role-staging"
}

resource "aws_iam_instance_profile" "Dublin-ecs-instance-profile-wifi" {
  name = "Dublin-ecs-instance-profile-wifi"
  path = "/"
  role = "Dublin-ecs-instance-role-wifi"
}

resource "aws_iam_instance_profile" "Dublin-frontend-ecs-instance-profile-staging" {
  name = "Dublin-frontend-ecs-instance-profile-staging"
  path = "/"
  role = "Dublin-frontend-ecs-instance-role-staging"
}

resource "aws_iam_instance_profile" "Dublin-frontend-ecs-instance-profile-wifi" {
  name = "Dublin-frontend-ecs-instance-profile-wifi"
  path = "/"
  role = "Dublin-frontend-ecs-instance-role-wifi"
}

resource "aws_iam_instance_profile" "Dublin-wifi-backend-bastion-instance-profile" {
  name = "Dublin-wifi-backend-bastion-instance-profile"
  path = "/"
  role = "Dublin-wifi-backend-bastion-instance-role"
}

resource "aws_iam_instance_profile" "GDSAdminAccessGovWifi" {
  name = "GDSAdminAccessGovWifi"
  path = "/"
  role = "GDSAdminAccessGovWifi"
}

resource "aws_iam_instance_profile" "London-ecs-instance-profile-staging" {
  name = "London-ecs-instance-profile-staging"
  path = "/"
  role = "London-ecs-instance-role-staging"
}

resource "aws_iam_instance_profile" "London-ecs-instance-profile-wifi" {
  name = "London-ecs-instance-profile-wifi"
  path = "/"
  role = "London-ecs-instance-role-wifi"
}

resource "aws_iam_instance_profile" "London-frontend-ecs-instance-profile-staging" {
  name = "London-frontend-ecs-instance-profile-staging"
  path = "/"
  role = "London-frontend-ecs-instance-role-staging"
}

resource "aws_iam_instance_profile" "London-frontend-ecs-instance-profile-wifi" {
  name = "London-frontend-ecs-instance-profile-wifi"
  path = "/"
  role = "London-frontend-ecs-instance-role-wifi"
}

resource "aws_iam_instance_profile" "London-staging-backend-bastion-instance-profile" {
  name = "London-staging-backend-bastion-instance-profile"
  path = "/"
  role = "London-staging-backend-bastion-instance-role"
}

resource "aws_iam_instance_profile" "London-wifi-backend-bastion-instance-profile" {
  name = "London-wifi-backend-bastion-instance-profile"
  path = "/"
  role = "London-wifi-backend-bastion-instance-role"
}
