output "db-hostname" {
  value = aws_db_instance.admin_db.address
}

output "aws-s3-admin-bucket-name" {
  description = "the name for the admin bucket"
  value = aws_s3_bucket.admin-bucket[0].id
}