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
