variable "Env-Name" {
  type    = string
  default = "staging"
}

variable "product-name" {
  type    = string
  default = "GovWifi"
}

variable "Env-Subdomain" {
  type        = string
  default     = "staging.wifi"
  description = "Environment-specific subdomain to use under the service domain."
}

variable "ssh-key-name" {
  type    = string
  default = "govwifi-staging-key-20180530"
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
  # eu-west-1, Amazon Linux AMI 2017.09.l x86_64 ECS HVM GP2
  default     = "ami-2d386654"
  description = "AMI id to launch, must be in the region specified by the region variable"
}

# Secrets

variable "london-api-base-url" {
  type        = string
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.london.staging.wifi.service.gov.uk:8443"
}

variable "dublin-api-base-url" {
  type        = string
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.dublin.staging.wifi.service.gov.uk:8443"
}

variable "user-rr-hostname" {
  type        = string
  description = "User details read replica hostname"
  default     = "users-rr.dublin.staging.wifi.service.gov.uk"
}

variable "auth-sentry-dsn" {
  type = string
}

variable "notification-email" {
}

variable "london-radius-ip-addresses" {
  type        = list(string)
  description = "Frontend RADIUS server IP addresses - London"
}

variable "dublin-radius-ip-addresses" {
  type        = list(string)
  description = "Frontend RADIUS server IP addresses - Dublin"
}

variable "prometheus-IP-london" {
}

variable "prometheus-IP-ireland" {
}

variable "grafana-IP" {
}

variable "administrator-IPs-list" {
  description = "Unused in this configuration"
}

variable "backend-subnet-IPs-list" {
  description = "Unused in this configuration"
}

variable "elb-public-IPs" {
  description = "Unused in this configuration"
}

variable "use_env_prefix" {
  default     = true
  type        = bool
  description = "Conditional to indicate whether to retrieve a secret with a env prefix in its name."
}
