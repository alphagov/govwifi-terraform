output "metrics_bucket_arn" {
  description = "the ARN for the metrics bucket"
  value       = "${aws_s3_bucket.metrics-bucket.arn}"
}
