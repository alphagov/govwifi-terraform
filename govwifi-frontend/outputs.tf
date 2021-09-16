output "frontend-vpc-id" {
  value = aws_vpc.wifi_frontend.id
}

output "frontend-subnet-id" {
  value = aws_subnet.wifi_frontend_subnet.*.id
}

output "fe-admin-in" {
  value = aws_security_group.fe_admin_in.id
}

output "fe-ecs-out" {
  value = aws_security_group.fe_ecs_out.id
}

output "fe-radius-in" {
  value = aws_security_group.fe_radius_in.id
}

output "fe-radius-out" {
  value = aws_security_group.fe_radius_out.id
}

output "ecs-instance-profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.id
}

output "wifi-frontend-subnet" {
  value = aws_subnet.wifi_frontend_subnet.*.id
}

