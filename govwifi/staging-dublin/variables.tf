variable "env_name" {
  type    = string
  default = "staging"
}

variable "product_name" {
  type    = string
  default = "GovWifi"
}

variable "env_subdomain" {
  type        = string
  default     = "staging.wifi"
  description = "Environment-specific subdomain to use under the service domain."
}

variable "ssh_key_name" {
  type    = string
  default = "staging-ec2-instances-20200717"
}

# Entries below should probably stay as is for different environments
#####################################################################

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_region_name" {
  type    = string
  default = "Dublin"
}

variable "backup_region_name" {
  type    = string
  default = "London"
}

variable "zone_count" {
  type    = string
  default = "3"
}

# Zone names and subnets MUST be static, can not be constructed from vars.
variable "zone_names" {
  type = map(any)

  default = {
    zone0 = "eu-west-1a"
    zone1 = "eu-west-1b"
    zone2 = "eu-west-1c"
  }
}

variable "ami" {
  # eu-west-1, Amazon Linux AMI 2017.09.l x86_64 ECS HVM GP2
  default     = "ami-2d386654"
  description = "AMI id to launch, must be in the region specified by the region variable"
}

variable "london_api_base_url" {
  type        = string
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.london.staging.wifi.service.gov.uk:8443"
}

variable "dublin_api_base_url" {
  type        = string
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.dublin.staging.wifi.service.gov.uk:8443"
}

variable "user_rr_hostname" {
  type        = string
  description = "User details read replica hostname"
  default     = "users-rr.dublin.staging.wifi.service.gov.uk"
}

variable "auth_sentry_dsn" {
  type = string
}

variable "notification_email" {
}

variable "prometheus_ip_london" {
}

variable "prometheus_ip_ireland" {
}

variable "london_radius_ip_addresses" {
  type        = list(any)
  description = "Frontend RADIUS server IP addresses - London"
}

variable "dublin_radius_ip_addresses" {
  type        = list(string)
  description = "Frontend RADIUS server IP addresses - Dublin"
}

variable "grafana_ip" {
}

variable "is_production_aws_account" {
  description = "Conditional to indicate if the enviroment is production or not."
  default     = false
  type        = bool
}
