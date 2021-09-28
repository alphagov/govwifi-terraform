output "backend-vpc-id" {
  value = aws_vpc.wifi_backend.id
}

output "backend-subnet-ids" {
  value = aws_subnet.wifi_backend_subnet.*.id
}

output "ecs-instance-profile-id" {
  value = aws_iam_instance_profile.ecs_instance_profile.id
}

output "ecs-service-role" {
  value = aws_iam_role.ecs_service_role.arn
}

output "rds-monitoring-role" {
  value = aws_iam_role.rds_monitoring_role.arn
}

output "be-admin-in" {
  value = aws_security_group.be_admin_in.id
}

output "vpc-cidr-block" {
  value = var.vpc-cidr-block
}

