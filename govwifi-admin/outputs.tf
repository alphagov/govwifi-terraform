output "db-hostname" {
  value = "${aws_db_instance.admin_db.address}"
}

output "admin-ec2-out-sg-id" {
  value = "${aws_security_group.admin-ec2-out.id}"
}
