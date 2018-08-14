output "db-hostname" {
  value = "${aws_db_instance.admin_db.address}"
}
