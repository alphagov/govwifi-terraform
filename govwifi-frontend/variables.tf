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

variable "dns-numbering-base" {}

variable "backend-base-url" {}

variable "elastic-ip-list" {
  type = "list"
}
