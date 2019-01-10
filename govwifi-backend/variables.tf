variable "Env-Name" {}

variable "Env-Subdomain" {}

variable "route53-zone-id" {}

variable "vpc-cidr-block" {}

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

variable "save-pp-data" {
  description = "Whether or not to save Performance Platform backup data. Value must be 0 or 1."
  default     = "0"
}
