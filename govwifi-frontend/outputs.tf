output "frontend-vpc-id" {
  value = "${aws_vpc.wifi-frontend.id}"
}

output "frontend-subnet-id" {
  value = "${aws_subnet.wifi-frontend-subnet.*.id}"
}

output "radius-box-elastic-ips" {
  value = "${aws_eip.radius.*.public_ip}"
}
