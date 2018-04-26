output "backend-vpc-id" {
  value = "${aws_vpc.wifi-backend.id}"
}

output "backend-subnet-ids" {
  value = ["${aws_subnet.wifi-backend-subnet.*.id}"]
}
