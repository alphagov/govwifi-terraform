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

variable "frontend-docker-image" {}

variable "raddb-docker-image" {}

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

variable "radiusd-params" {
  default = "-X"
}

variable "users" {
  type = "list"
}

variable "rack-env" {
  default = ""
}

variable "create-ecr" {
  description = "Whether or not to create ECR repository"
  default     = false
}

variable "bastion-ips" {
  description = "The list of allowed hosts to connect to the ec2 instances"
  type        = "list"
  default     = []
}

variable "route53-critical-notifications-arn" {
  type = "string"
}

variable "devops-notifications-arn" {
  type = "string"
}

variable "admin-bucket-name" {
  type = "string"
}
