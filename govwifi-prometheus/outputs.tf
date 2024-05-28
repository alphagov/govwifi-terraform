output "eip_public_ip" {
  value = aws_eip.eip.public_ip
}

output "prometheus_security_group_id" {
  value = aws_security_group.prometheus-ec2-in-out.id
}
