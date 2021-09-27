variable "Env-Name" {
  type    = string
  default = "staging-temp"
}

variable "Stage-Name" {
  type    = string
  default = "staging"
}

variable "product-name" {
  type    = string
  default = "GovWifi"
}

variable "Env-Subdomain" {
  type        = string
  default     = "staging-temp.wifi"
  description = "Environment-specific subdomain to use under the service domain."
}

variable "ssh-key-name" {
  type    = string
  default = "staging-temp-ec2-instances-20200717"
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

variable "london-api-base-url" {
  type        = string
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.london.staging-temp.wifi.service.gov.uk:8443"
}

variable "dublin-api-base-url" {
  type        = string
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.dublin.staging-temp.wifi.service.gov.uk:8443"
}

variable "user-rr-hostname" {
  type        = string
  description = "User details read replica hostname"
  default     = "users-rr.dublin.staging-temp.wifi.service.gov.uk"
}

variable "auth-sentry-dsn" {
  type = string
}

variable "notification-email" {
}

variable "prometheus-IP-london" {
}

variable "prometheus-IP-ireland" {
}

variable "london-radius-ip-addresses" {
  type        = list(any)
  description = "Frontend RADIUS server IP addresses - London"
}

variable "dublin-radius-ip-addresses" {
  type        = list(string)
  description = "Frontend RADIUS server IP addresses - Dublin"
}

variable "grafana-IP" {
}

variable "use_env_prefix" {
  default     = false
  type        = bool
  description = "Conditional to indicate whether to retrieve a secret with a env prefix in its name. For the secondary account the value can be set to false. The 'staging' prefix is redundant since the secondary account will be used for staging"
}

variable "backup_mysql_rds" {
  description = "Conditional to indicate whether to make artifacts for and run RDS MySQL backups."
  default     = false
  type        = bool
}

variable "is_production_aws_account" {
  description = "Conditional to indicate if the enviroment is production or not."
  default     = false
  type        = bool
}
