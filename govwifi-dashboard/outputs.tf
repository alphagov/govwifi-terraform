output "metrics-bucket-name" {
  description = "the name for the metrics bucket"
  value       = aws_s3_bucket.metrics_bucket.id
}

