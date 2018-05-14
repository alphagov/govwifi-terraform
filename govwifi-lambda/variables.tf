variable "aws-region-name" {}

variable "Env-Name" {}

variable "Env-Subdomain" {}

variable "db-user" {}

variable "db-password" {}

variable "db-sg-list" {
  type = "list"
}

variable "db-subnet-ids" {
  type = "list"
}

variable "enable-user-del-cron" {
  description = "Whether to enable user deletion trigger."
  default     = false
}

variable "enable-session-del-cron" {
  description = "Whether to enable session deletion trigger."
  default     = false
}
