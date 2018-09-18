variable "Env-Name" {}

variable "Env-Subdomain" {}

variable "route53-zone-id" {}

variable "aws-region" {}

variable "aws-region-name" {}

variable "ami" {
  description = "AMI id to launch, must be in the region specified by the region variable"
}

variable "ssh-key-name" {}

variable "backend-instance-count" {}

variable "backend-min-size" {}

variable "backend-cpualarm-count" {}

variable "backend-elb-count" {}

variable "aws-account-id" {}

variable "elb-ssl-cert-arn" {}

variable "admin-db-name" {}

variable "admin-db-user" {}

variable "admin-db-password" {}

variable "admin-db-hostname" {}

variable "docker-image" {}

variable "rack-env" {}

variable "radius-server-ips" {}

variable "sentry-dsn" {}

variable "shared-key" {}

variable "elb-sg-list" {
  type = "list"
}

variable "backend-sg-list" {
  type = "list"
}

variable "critical-notifications-arn" {}

variable "capacity-notifications-arn" {}

variable "users" {
  type = "list"
}

variable "zone-names" {
  type = "map"
}

variable "subnet-ids" {
  type = "list"
}

variable "ecs-instance-profile-id" {}
variable "ecs-service-role" {}

variable "ecr-repository-count" {
  default     = 0
  description = "Whether or not to create ECR repository"
}

variable "health_check_grace_period" {
  default     = "300"
  description = "Time after instance comes into service before checking health"
}
