variable "Env-Name" {
  type    = "string"
  default = "wifi"
}

variable "product-name" {
  type    = "string"
  default = "GovWifi"
}

variable "Env-Subdomain" {
  type        = "string"
  default     = "wifi"
  description = "Environment-specific subdomain to use under the service domain."
}

variable "ssh-key-name" {
  type    = "string"
  default = "govwifi-key-20180530"
}

# Entries below should probably stay as is for different environments
#####################################################################
variable "aws-region" {
  type    = "string"
  default = "eu-west-1"
}

variable "aws-region-name" {
  type    = "string"
  default = "Dublin"
}

variable "backup-region-name" {
  type    = "string"
  default = "London"
}

variable "zone-count" {
  type    = "string"
  default = "3"
}

# Zone names and subnets MUST be static, can not be constructed from vars.
variable "zone-names" {
  type = "map"

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
variable "db-user" {
  type        = "string"
  description = "Database username"
}

variable "db-password" {
  type        = "string"
  description = "Database main password"
}

variable "hc-key" {
  type        = "string"
  description = "Health check process shared secret"
}

variable "hc-ssid" {
  type        = "string"
  description = "Healt check simulated SSID"
}

variable "hc-identity" {
  type        = "string"
  description = "Healt check identity"
}

variable "hc-password" {
  type        = "string"
  description = "Healt check password"
}

variable "shared-key" {
  type        = "string"
  description = "A random key to be shared between the fronend and backend to retrieve initial client setup."
}

variable "aws-account-id" {
  type        = "string"
  description = "The ID of the AWS tenancy."
}

variable "aws-parent-account-id" {
  type        = "string"
  description = "The ID of the AWS parent account."
}

variable "docker-image-path" {
  type        = "string"
  description = "ARN used to identify the common path element used for the docker image repositories."
}

variable "route53-zone-id" {
  type        = "string"
  description = "Zone ID used by the Route53 DNS service."
}

variable "user-signup-sentry-dsn" {
  type    = "string"
  default = ""
}

variable "performance-url" {
  default     = ""
  type        = "string"
  description = "URL endpoint leading to Performance platform API, with a trailing slash at the end"
}

variable "performance-dataset" {
  default     = ""
  type        = "string"
  description = "Dataset to which Performance statistics should be saved e.g `gov-wifi`"
}

variable "performance-bearer-volumetrics" {
  default     = ""
  type        = "string"
  description = "Bearer token for `volumetrics` Performance platform statistics"
}

variable "performance-bearer-completion-rate" {
  default     = ""
  type        = "string"
  description = "Bearer token for `completion-rate` Performance platform statistics"
}

variable "performance-bearer-active-users" {
  default     = ""
  type        = "string"
  description = "Bearer token for `active-users` Performance platform statistics"
}

variable "performance-bearer-unique-users" {
  default     = ""
  type        = "string"
  description = "Bearer token for `unique-users` Performance platform statistics"
}

variable "auth-sentry-dsn" {
  type = "string"
}

variable "safe-restart-sentry-dsn" {
  type = "string"
}

variable "logging-sentry-dsn" {
  type    = "string"
  default = ""
}

variable "london-api-base-url" {
  type        = "string"
  description = "Base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.london.wifi.service.gov.uk:8443"
}

variable "dublin-api-base-url" {
  type        = "string"
  description = "Dublin - base URL for authentication, user signup and logging APIs"
  default     = "https://api-elb.dublin.wifi.service.gov.uk:8443"
}

variable "user-db-username" {
  type        = "string"
  description = "User details database username"
}

variable "user-db-password" {
  type        = "string"
  description = "User details database password"
}

variable "user-db-hostname" {
  type        = "string"
  description = "User details database hostname"
  default     = "users-db.london.production.wifi.service.gov.uk"
}

variable "user-rr-hostname" {
  type        = "string"
  description = "User details read replica hostname"
  default     = "users-rr.dublin.production.wifi.service.gov.uk"
}

variable "rds-kms-key-id" {
  type = "string"
}

variable "critical-notification-email" {
  type = "string"
}

variable "capacity-notification-email" {
  type = "string"
}

variable "devops-notification-email" {
  type = "string"
}

variable "prometheus-IPs" {}
