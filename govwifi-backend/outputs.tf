output "backend_vpc_id" {
  value = aws_vpc.wifi_backend.id
}

output "backend_subnet_ids" {
  value = [for subnet in aws_subnet.wifi_backend_subnet : subnet.id]
}

output "backend_private_subnet_ids" {
  value = [for subnet in aws_subnet.wifi_backend_private_subnets : subnet.id]
}

output "ecs_instance_profile_id" {
  value = aws_iam_instance_profile.ecs_instance_profile.id
}

output "ecs_service_role" {
  value = aws_iam_role.ecs_service_role.arn
}

output "rds_monitoring_role" {
  value = aws_iam_role.rds_monitoring_role.arn
}

output "be_admin_in" {
  value = aws_security_group.be_admin_in.id
}

output "vpc_cidr_block" {
  value = var.vpc_cidr_block
}

output "rds_mysql_backup_bucket" {
  value = var.backup_mysql_rds ? aws_s3_bucket.rds_mysql_backup_bucket[0].id : null
}

output "nat_gateway_elastic_ips" {
  value = [for eip in aws_eip.for_nat_gateway_for_private_subnets : eip.public_ip]
}
