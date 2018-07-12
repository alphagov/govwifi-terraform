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

variable "db-user" {}

variable "db-password" {}

variable "db-hostname" {}

variable "db-read-replica-hostname" {}

variable "rack-env" {}

variable "radius-server-ips" {}

variable "authentication-sentry-dsn" {}

variable "user-signup-sentry-dsn" {}

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

variable "subnet-ids" {
  type = "list"
}

variable "ecs-instance-profile-id" {}
variable "ecs-service-role" {}

variable "health_check_grace_period" {
  default     = "300"
  description = "Time after instance comes into service before checking health"
}

variable "auth-docker-image" {}

variable "user-signup-docker-image" {}

variable "authorised-email-domains-regex" {
  description = "Regex used as matcher for whether an incoming email is from a government address."
}

variable "notify-api-key" {
  description = "API key used to authenticate with GOV.UK Notify"
}

variable "ecr-repository-count" {
  default     = 0
  description = "Whether or not to create ECR repository"
}

variable "wordlist-bucket-count" {
  default     = 0
  description = "Whether or not to create wordlist bucket"
}

variable "wordlist-file-path" {
  default     = ""
  description = "The local path of the wordlist which gets uploaded to S3"
}

variable "vpc-id" {}
