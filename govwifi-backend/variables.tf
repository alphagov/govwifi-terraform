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

variable "bastion-server-ip" {}

variable "bastion-ssh-key-name" {}

variable "bastion-auth-keys" {}

variable "bastion-identity" {}

variable "bastion-set-cronjobs" {}

variable "ssh-key-name" {}

variable "backend-instance-count" {}

variable "backend-min-size" {}

variable "backend-cpualarm-count" {}

variable "aws-account-id" {}

variable "elb-ssl-cert-arn" {}

variable "docker-image" {}

variable "db-user" {}

variable "db-password" {}

variable "radius-server-ips" {}

variable "shared-key" {}

variable "db-instance-count" {}

variable "db-replica-count" {}

variable "db-backup-retention-days" {}

variable "db-encrypt-at-rest" {}

variable "db-instance-type" {}

variable "db-monitoring-interval" {}

variable "db-storage-gb" {}

variable "db-maintenance-window" {}

variable "db-backup-window" {}

variable "rr-instance-type" {}

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

variable "ithc-backend-instance-count" {
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

variable "users" {
  type = "list"
}