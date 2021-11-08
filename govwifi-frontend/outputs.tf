output "frontend_vpc_id" {
  value = aws_vpc.wifi_frontend.id
}

output "frontend_subnet_id" {
  value = aws_subnet.wifi_frontend_subnet.*.id
}

output "fe_admin_in" {
  value = aws_security_group.fe_admin_in.id
}

output "fe_ecs_out" {
  value = aws_security_group.fe_ecs_out.id
}

output "fe_radius_in" {
  value = aws_security_group.fe_radius_in.id
}

output "fe_radius_out" {
  value = aws_security_group.fe_radius_out.id
}

output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.id
}

output "wifi_frontend_subnet" {
  value = aws_subnet.wifi_frontend_subnet.*.id
}

