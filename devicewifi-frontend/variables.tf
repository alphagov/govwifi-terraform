variable "Env-Name" {}

variable "Env-Subdomain" {}

variable "aws-region" {}

variable "subnet-id" {
  type = "list"
}

variable "ecs-instance-profile-id" {}

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

variable "logging-api-base-url" {}

variable "auth-api-base-url" {}

variable "enable-detailed-monitoring" {}

variable "radiusd-params" {
  default = ""
}

variable "users" {
  type   = "list"
}

variable "rack-env" {
  default   = ""
}

variable "ecr-repository-count" {
  description = "Whether or not to create ECR repository"
  default     = 0
}
