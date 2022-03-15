output "eip_public_ip" {
  value = aws_eip.grafana_eip.public_ip
}
