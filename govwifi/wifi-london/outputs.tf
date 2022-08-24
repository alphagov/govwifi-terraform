output "replica_admin_app_data_s3_bucket_name" {
  value = module.govwifi_admin.replica_app_data_s3_bucket_name
}

output "backend_vpc_id" {
  value = module.backend.backend_vpc_id
}

output "logging_api_internal_dns_name" {
  value = module.api.logging_api_internal_dns_name
}
