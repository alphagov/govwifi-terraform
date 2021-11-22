variable "env_name" {
  type    = string
  default = "staging-temp"
}

variable "product_name" {
  type    = string
  default = "GovWifi"
}

variable "env_subdomain" {
  type        = string
  default     = "staging-temp.wifi"
  description = "Environment-specific subdomain to use under the service domain."
}

variable "ssh_key_name" {
  type    = string
  default = "staging-temp-ec2-instances-20200717"
}

# Entries below should probably stay as is for different environments
#####################################################################
variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "aws_region_name" {
  type    = string
  default = "London"
}

variable "backup_region_name" {
  type    = string
  default = "Dublin"
}

variable "zone_count" {
  type    = string
  default = "3"
}

# Zone names and subnets MUST be static, can not be constructed from vars.
variable "zone_names" {
  type = map(any)

  default = {
    zone0 = "eu-west-2a"
    zone1 = "eu-west-2b"
    zone2 = "eu-west-2c"
  }
}

variable "ami" {
  # eu-west-2, Amazon Linux AMI 2017.09.l x86_64 ECS HVM GP2
  default     = "ami-2218f945"
  description = "AMI id to launch, must be in the region specified by the region variable"
}

# Secrets

variable "auth_sentry_dsn" {
  type = string
}

variable "safe_restart_sentry_dsn" {
  type = string
}

variable "public_google_api_key" {
  type    = string
  default = "xxxxxxxxxxxxxxxxxxxxx"
}

variable "user_signup_sentry_dsn" {
  type = string
}

variable "logging_sentry_dsn" {
  type = string
}

variable "admin_sentry_dsn" {
  type = string
}

variable "user_db_hostname" {
  type        = string
  description = "User details database hostname"
  default     = "users-db.london.staging-temp.wifi.service.gov.uk"
}

variable "user_rr_hostname" {
  type        = string
  description = "User details read replica hostname"
  default     = "users-rr.london.staging-temp.wifi.service.gov.uk"
}

variable "zendesk_api_user" {
  type        = string
  description = "Username for authenticating with Zendesk API"
}

variable "london_radius_ip_addresses" {
  type        = list(any)
  description = "Frontend RADIUS server IP addresses - London"
}

variable "dublin_radius_ip_addresses" {
  type        = list(any)
  description = "Frontend RADIUS server IP addresses - Dublin"
}

variable "london_api_base_url" {
  type        = string
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.london.staging-temp.wifi.service.gov.uk:8443"
}

variable "notification_email" {
}

variable "prometheus_ip_london" {
}

variable "prometheus_ip_ireland" {
}

variable "grafana_ip" {
}

variable "backup_mysql_rds" {
  description = "Conditional to indicate whether to make artifacts for and run RDS MySQL backups."
  default     = true
  type        = bool
}

variable "is_production_aws_account" {
  description = "Conditional to indicate if the environment is production or not."
  default     = false
  type        = bool
}
