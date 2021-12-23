output "user_api_notification_arn" {
  description = "Arn of user api notification topic"
  value       = aws_sns_topic.govwifi_email_notifications.arn
}
