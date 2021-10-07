variable "Env-Name" {
}

variable "env" {
}

variable "Env-Subdomain" {
}

variable "route53-zone-id" {
}

variable "vpc-cidr-block" {
}

variable "aws-account-id" {
}

variable "aws-region" {
}

variable "aws-region-name" {
}

variable "administrator-IPs" {
}

variable "frontend-radius-IPs" {
}

variable "zone-count" {
}

variable "zone-names" {
  type = map(string)
}

variable "zone-subnets" {
  type = map(string)
}

variable "enable-bastion" {
  default = 1
}

variable "bastion-ami" {
}

variable "bastion-instance-type" {
}

variable "bastion-server-ip" {
}

variable "bastion-ssh-key-name" {
}

variable "user-db-hostname" {
}

variable "user-rr-hostname" {
}

variable "db-instance-count" {
}

variable "db-replica-count" {
}

variable "user-db-replica-count" {
  default = 0
}

variable "db-backup-retention-days" {
}

variable "db-encrypt-at-rest" {
}

variable "session-db-instance-type" {
}

variable "user-db-instance-type" {
}

variable "db-monitoring-interval" {
}

variable "session-db-storage-gb" {
}

variable "user-db-storage-gb" {
}

variable "db-maintenance-window" {
}

variable "db-backup-window" {
}

variable "rr-instance-type" {
}

variable "rr-storage-gb" {
}

variable "user-rr-instance-type" {
  default = "db.t2.medium"
}

variable "critical-notifications-arn" {
}

variable "capacity-notifications-arn" {
}

variable "enable-bastion-monitoring" {
}

variable "users" {
  type = list(string)
}

variable "user-replica-source-db" {
  type    = string
  default = ""
}

variable "prometheus-IP-london" {
}

variable "prometheus-IP-ireland" {
}

variable "grafana-IP" {
}

variable "use_env_prefix" {
}

variable "backup_mysql_rds" {
  description = "Whether or not to create objects to and make backups of MySQL RDS data"
  default     = false
  type        = bool
}

variable "db-storage-alarm-threshold" {
  description = "DB storage threshold used for alarms. Value varies based on environment and storage average."
  type        = number
}

variable "is_production_aws_account" {
}
