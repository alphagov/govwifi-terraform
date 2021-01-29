variable "Env-Name" {}

variable "aws-region" {}

variable "ssh-key-name" {}

variable "backend-subnet-ids" {
  type = "list"
}

variable "be-admin-in" {}

variable "create_grafana_server" {
  default = "0"
}
