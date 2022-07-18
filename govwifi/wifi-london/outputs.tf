output "admin_app_data_s3_bucket_name" {
  value = module.govwifi_admin.app_data_s3_bucket_name
}

output "us_east_1_pagerduty_topic_arn" {
  value = module.us_east_1_pagerduty.topic_arn
}

output "backend_vpc_id" {
  value = module.backend.backend_vpc_id
}
