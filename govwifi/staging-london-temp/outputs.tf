output "admin_app_data_s3_bucket_name" {
  value = module.govwifi_admin.app_data_s3_bucket_name
}

output "us_east_1_notifications_topic_arn" {
  value = module.route53-notifications.topic_arn
}
