variable "Env-Name" {}

variable "aws-region" {}

variable "aws-region-name" {}

variable "performance-instance-count" {}

variable "performance-ami" {}

variable "performance-instance-type" {}

variable "performance-server-ip" {}

variable "performance-ssh-key-name" {}

variable "performance-subnet-id" {}

variable "performance-sg-list" {
  type = "list"
}
