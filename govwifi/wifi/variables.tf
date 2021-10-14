variable "Env-Name" {
  type    = string
  default = "wifi"
}

variable "product-name" {
  type    = string
  default = "GovWifi"
}

variable "Env-Subdomain" {
  type        = string
  default     = "wifi"
  description = "Environment-specific subdomain to use under the service domain."
}

variable "ssh-key-name" {
  type    = string
  default = "govwifi-key-20180530"
}

# Entries below should probably stay as is for different environments
#####################################################################
variable "aws-region" {
  type    = string
  default = "eu-west-1"
}

variable "aws-region-name" {
  type    = string
  default = "Dublin"
}

variable "backup-region-name" {
  type    = string
  default = "London"
}

variable "zone-count" {
  type    = string
  default = "3"
}

# Zone names and subnets MUST be static, can not be constructed from vars.
variable "zone-names" {
  type = map(string)

  default = {
    zone0 = "eu-west-1a"
    zone1 = "eu-west-1b"
    zone2 = "eu-west-1c"
  }
}

variable "ami" {
  # eu-west-1, Amazon Linux AMI 2.0.20210819 x86_64 ECS HVM GP2
  default     = "ami-0edfed61b9e44e914"
  description = "AMI id to launch, must be in the region specified by the region variable"
}

# Secrets

variable "london_radius_ip_addresses" {
  type        = list(string)
  description = "Frontend RADIUS server IP addresses - London"
}

variable "dublin_radius_ip_addresses" {
  type        = list(string)
  description = "Frontend RADIUS server IP addresses - Dublin"
}

variable "auth_sentry_dsn" {
  type = string
}

variable "safe_restart_sentry_dsn" {
  type = string
}

variable "logging_sentry_dsn" {
  type    = string
  default = ""
}

variable "london-api-base-url" {
  type        = string
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.london.wifi.service.gov.uk:8443"
}

variable "dublin-api-base-url" {
  type        = string
  description = "Dublin - base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.dublin.wifi.service.gov.uk:8443"
}

variable "user-db-hostname" {
  type        = string
  description = "User details database hostname"
  default     = "users-db.london.production.wifi.service.gov.uk"
}

variable "user-rr-hostname" {
  type        = string
  description = "User details read replica hostname"
  default     = "users-rr.dublin.production.wifi.service.gov.uk"
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

variable "use_env_prefix" {
  default     = false
  type        = bool
  description = "Conditional to indicate whether to retrieve a secret with a env prefix in its name."
}

variable "is_production_aws_account" {
  description = "Conditional to indicate if the enviroment is production or not."
  default     = true
  type        = bool
}
