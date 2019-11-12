variable "env" {}

variable "Env-Name" {}

variable "Env-Subdomain" {}

variable "route53-zone-id" {}

variable "aws-region" {}

variable "aws-region-name" {}

variable "alarm-count" {
  default = 1
}

variable "event-rule-count" {
  default = 1
}

variable "ami" {
  description = "AMI id to launch, must be in the region specified by the region variable"
}

variable "ssh-key-name" {}

variable "backend-instance-count" {}

variable "authorisation-api-count" {
  default = 2
}

variable "backend-min-size" {}

variable "backend-max-size" {
  default = 10
}

variable "backend-cpualarm-count" {}

variable "backend-elb-count" {}

variable "aws-account-id" {}

variable "elb-ssl-cert-arn" {}

variable "user-signup-enabled" {
  default = 1
}

variable "logging-enabled" {
  default = 1
}

variable "safe-restart-enabled" {
  default = 1
}

variable "safe-restart-sentry-dsn" {
  default = ""
}

variable "admin-db-hostname" {}

variable "admin-db-username" {}

variable "admin-db-password" {}

variable "admin-db-name" {}

variable "user-db-username" {}

variable "user-db-password" {}

variable "user-db-hostname" {}

variable "user-rr-hostname" {}

variable "user-db-name" {}

variable "db-user" {}

variable "db-password" {}

variable "db-hostname" {}

variable "db-name" {}

variable "db-read-replica-hostname" {}

variable "rack-env" {}

variable "performance-url" {
  default = ""
}

variable "performance-dataset" {
  default = ""
}

variable "performance-bearer-volumetrics" {
  default = ""
}

variable "performance-bearer-completion-rate" {
  default = ""
}

variable "performance-bearer-active-users" {
  default = ""
}

variable "performance-bearer-roaming-users" {
  default = ""
}

variable "performance-bearer-unique-users" {
  default = ""
}

variable "radius-server-ips" {
  type = "list"
}

variable "authentication-sentry-dsn" {}

variable "user-signup-sentry-dsn" {}

variable "logging-sentry-dsn" {}

variable "shared-key" {}

variable "elb-sg-list" {
  type = "list"
}

variable "backend-sg-list" {
  type = "list"
}

variable "critical-notifications-arn" {}

variable "capacity-notifications-arn" {}

variable "devops-notifications-arn" {}

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

variable "logging-docker-image" {}

variable "safe-restart-docker-image" {}

variable "database-backup-docker-image" {}

variable "notify-api-key" {
  default     = ""
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

variable "user-signup-api-base-url" {
  description = "DEPRECATED"
  default     = ""
}

variable "iam-count" {
  default     = 0
  description = "Whether or not to iam roles"
}

variable "admin-bucket-name" {
  default     = ""
  type        = "string"
  description = "Name of the admin S3 bucket"
}

variable "background-jobs-enabled" {
  default = 0
}

variable "firetext-token" {
  type    = "string"
  default = ""
}

variable "govnotify-bearer-token" {
  type    = "string"
  default = ""
}

variable "user-signup-api-is-public" {
  default = false
}
