output "frontend-vpc-id" {
  value = aws_vpc.wifi-frontend.id
}

output "frontend-subnet-id" {
  value = aws_subnet.wifi-frontend-subnet.*.id
}

output "fe-admin-in" {
  value = aws_security_group.fe-admin-in.id
}

output "fe-ecs-out" {
  value = aws_security_group.fe-ecs-out.id
}

output "fe-radius-in" {
  value = aws_security_group.fe-radius-in.id
}

output "fe-radius-out" {
  value = aws_security_group.fe-radius-out.id
}

output "ecs-instance-profile" {
  value = aws_iam_instance_profile.ecs-instance-profile.id
}

output "wifi-frontend-subnet" {
  value = aws_subnet.wifi-frontend-subnet.*.id
}

