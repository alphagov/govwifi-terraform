output "frontend-vpc-id" {
  value = "${aws_vpc.wifi-frontend.id}"
}

output "frontend-subnet-id" {
  value = "${aws_subnet.wifi-frontend-subnet.*.id}"
}

output "route_table_id" {
  value = "${aws_vpc.wifi-frontend.main_route_table_id}" 
}

output "frontend_security_group" {
  value = "${aws_security_group.fe-radius-out.id}"
}
