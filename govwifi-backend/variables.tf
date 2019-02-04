variable "Env-Name" {}

variable "env" {}

variable "Env-Subdomain" {}

variable "route53-zone-id" {}

variable "vpc-cidr-block" {}

variable "aws-account-id" {}

variable "aws-region" {}

variable "aws-region-name" {}

variable "zone-count" {}

variable "zone-names" {
  type = "map"
}

variable "zone-subnets" {
  type = "map"
}

variable "bastion-ami" {}

variable "bastion-instance-type" {}

variable "bastion-server-ip" {}

variable "bastion-ssh-key-name" {}

variable "db-user" {}

variable "db-password" {}

variable "user-db-username" {}

variable "user-db-password" {}

variable "user-db-hostname" {}

variable "db-instance-count" {}

variable "db-replica-count" {}

variable "db-backup-retention-days" {}

variable "db-encrypt-at-rest" {}

variable "session-db-instance-type" {}

variable "user-db-instance-type" {}

variable "db-monitoring-interval" {}

variable "session-db-storage-gb" {}

variable "user-db-storage-gb" {}

variable "db-maintenance-window" {}

variable "db-backup-window" {}

variable "rr-instance-type" {}

variable "rr-storage-gb" {}


variable "mgt-sg-list" {
  type = "list"
}

variable "db-sg-list" {
  type = "list"
}

variable "critical-notifications-arn" {}

variable "capacity-notifications-arn" {}

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
variable "save-pp-data" {
  description = "Whether or not to save Performance Platform backup data. Value must be 0 or 1."
  default     = "0"
}

variable "pp-domain-name" {
  default = ""
}
