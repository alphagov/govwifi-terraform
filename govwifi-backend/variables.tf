variable "Env-Name" {}

variable "Env-Subdomain" {}

variable "route53-zone-id" {}

variable "mail-exchange-server" {}

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

variable "ami" {
  description = "AMI id to launch, must be in the region specified by the region variable"
}

variable "bastion-ami" {}

variable "bastion-instance-type" {}

variable "ssh-key-name" {}

variable "backend-instance-count" {}

variable "aws-account-id" {}

variable "elb-ssl-cert-arn" {}

variable "docker-image" {}

variable "db-user" {}

variable "db-password" {}

variable "radius-server-ips" {}

variable "shared-key" {}

variable "db-instance-count" {}

variable "db-backup-retention-days" {}

variable "db-encrypt-at-rest" {}

variable "db-instance-type" {}

variable "db-monitoring-interval" {}

variable "db-storage-gb" {}

variable "db-maintenance-window" {}

variable "cache-node-type" {}

variable "elb-sg-list" {
  type = "list"
}

variable "backend-sg-list" {
  type = "list"
}

variable "mgt-sg-list" {
  type = "list"
}

variable "db-sg-list" {
  type = "list"
}

variable "cache-sg-list" {
  type = "list"
}

variable "legacy-bastion-user" {}

variable "critical-notifications-arn" {}

variable "enable-bastion-monitoring" {}
