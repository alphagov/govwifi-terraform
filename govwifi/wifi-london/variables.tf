variable "ssh_key_name" {
  type    = string
  default = "govwifi-key-20180530"
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
  type = map(string)

  default = {
    zone0 = "eu-west-2a"
    zone1 = "eu-west-2b"
    zone2 = "eu-west-2c"
  }
}

variable "ami" {
  # eu-west-2, Amazon Linux AMI 2.0.20210819 x86_64 ECS HVM GP2
  default     = "ami-0820c1f2c6fc9dff1"
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
  default = "AIzaSyCz1cPYKamsA_ZJCygL9EY0Zq6stkazTco"
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
  default     = "users-db.london.production.wifi.service.gov.uk"
}

variable "user_rr_hostname" {
  type        = string
  description = "User details read replica hostname"
  default     = "users-rr.london.production.wifi.service.gov.uk"
}

variable "zendesk_api_user" {
  type        = string
  description = "User for authenticating with Zendesk API"
}

variable "london_radius_ip_addresses" {
  type        = list(string)
  description = "Frontend RADIUS server IP addresses - London"
}

variable "dublin_radius_ip_addresses" {
  type        = list(string)
  description = "Frontend RADIUS server IP addresses - Dublin"
}

variable "london_api_base_url" {
  type        = string
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.london.wifi.service.gov.uk:8443"
}

variable "critical_notification_email" {
  type = string
}

variable "capacity_notification_email" {
  type = string
}

variable "devops_notification_email" {
  type = string
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
  description = "Conditional to indicate if the enviroment is production or not."
  default     = true
  type        = bool
}
