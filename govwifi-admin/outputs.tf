output "db-hostname" {
  value = "${aws_db_instance.admin_db.address}"
}

output "db-name" {
  value = "${aws_db_instance.admin_db.name}"
}

output "db-username" {
  value = "${aws_db_instance.admin_db.username}"
}

output "db-password" {
  value = "${aws_db_instance.admin_db.password}"
}