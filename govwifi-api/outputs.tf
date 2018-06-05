output "loadbalancer-in-sg-id" {
  value = "${aws_security_group.loadbalancer-in.id}"
}

output "loadbalancer-out-sg-id" {
  value = "${aws_security_group.loadbalancer-out.id}"
}

output "api-in-sg-id" {
  value = "${aws_security_group.api-in.id}"
}

output "api-out-sg-id" {
  value = "${aws_security_group.api-out.id}"
}
