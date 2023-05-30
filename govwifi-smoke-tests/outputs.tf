output "eip_public_ips" {
  value = [aws_eip.smoke_tests_a.public_ip, aws_eip.smoke_tests_b.public_ip]
}