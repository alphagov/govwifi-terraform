output "topic_arn" {
  value = var.is_production == 1 ? aws_sns_topic.smoke_tests[0].arn : ""
}
