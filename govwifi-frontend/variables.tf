variable "Env-Name" {}

variable "Env-Subdomain" {}

variable "route53-zone-id" {}

variable "vpc-cidr-block" {}

variable "aws-region" {}

variable "aws-region-name" {}

variable "zone-count" {}

variable "zone-names" {
  type = "map"
}

variable "zone-subnets" {
  type = "map"
}

variable "radius-instance-count" {}

variable "radius-instance-sg-ids" {
  type = "list"
}

variable "docker-image" {}

variable "ami" {
  description = "AMI id to launch, must be in the region specified by the region variable"
}

variable "ssh-key-name" {}

variable "shared-key" {}

variable "healthcheck-radius-key" {}
variable "healthcheck-ssid" {}
variable "healthcheck-identity" {}
variable "healthcheck-password" {}

variable "dns-numbering-base" {}

variable "logging-api-base-url" {}

variable "auth-api-base-url" {}

variable "elastic-ip-list" {
  type = "list"
}

variable "enable-detailed-monitoring" {}

variable "ithc-frontend-instance-count" {
  default = "0"
}
variable "ithc-ami" {
  default = ""
}
variable "ithc-instance-type" {
  default = ""
}
variable "ithc-server-ip" {
  default = ""
}
variable "ithc-ssh-key-name" {
  default = ""
}
variable "ithc-sg-list" {
  type    = "list"
  default = []
}
variable "radiusd-params" {
  default = ""
}

variable "users" {
  type   = "list"
}

variable "rack-env" {
  default   = ""
}

variable "create-ecr" {
  description = "Whether or not to create ECR repository"
  default     = false
}
