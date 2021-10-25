output "db-hostname" {
  value = aws_db_instance.admin_db.address
}

output "app_data_s3_bucket_name" {
  description = "Name (id) for the admin bucket"
  value       = aws_s3_bucket.admin_bucket[0].id
}

