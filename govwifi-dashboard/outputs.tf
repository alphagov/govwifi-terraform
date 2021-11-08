output "metrics_bucket_name" {
  description = "the name for the metrics bucket"
  value       = aws_s3_bucket.metrics_bucket.id
}

output "export_data_bucket_name" {
  description = "the name for the bucket used to export data to data.gov.uk"
  value       = aws_s3_bucket.export_data_bucket.id
}

