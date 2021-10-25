variable "env" {
}

variable "Env-Name" {
}

variable "Env-Subdomain" {
}

variable "route53-zone-id" {
}

variable "aws-region" {
}

variable "aws-region-name" {
}

variable "alarm-count" {
  default = 1
}

variable "event-rule-count" {
  default = 1
}

variable "backend-instance-count" {
}

variable "authorisation-api-count" {
  default = 3
}

variable "backend-elb-count" {
}

variable "aws-account-id" {
}

variable "user-signup-enabled" {
  default = 1
}

variable "logging-enabled" {
  default = 1
}

variable "safe-restart-enabled" {
  default = 1
}

variable "safe_restart_sentry_dsn" {
  default = ""
}

variable "user-db-hostname" {
}

variable "user-rr-hostname" {
}

variable "db-hostname" {
}

variable "rack-env" {
}

variable "sentry-current-env" {
}

variable "radius-server-ips" {
  type = list(string)
}

variable "authentication_sentry_dsn" {
}

variable "user_signup_sentry_dsn" {
  default = ""
}

variable "logging_sentry_dsn" {
  default = ""
}

variable "backend-sg-list" {
  type = list(string)
}

variable "devops-notifications-arn" {
}

variable "notification_arn" {
  description = "Notification ARN for alerts. In production alerts are sent to PagerDuty, but in staging alerts are sent to an email group."
  type        = string
}

variable "subnet-ids" {
  type = list(string)
}

variable "auth-docker-image" {
}

variable "user-signup-docker-image" {
}

variable "logging-docker-image" {
}

variable "safe-restart-docker-image" {
}

variable "backup-rds-to-s3-docker-image" {
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

variable "vpc-id" {
}

variable "admin-bucket-name" {
  default     = ""
  type        = string
  description = "Name of the admin S3 bucket"
}

variable "firetext-token" {
  type    = string
  default = ""
}

variable "user-signup-api-is-public" {
  default = 0
}

variable "metrics-bucket-name" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket to write metrics into"
}

variable "export-data-bucket-name" {
  type        = string
  default     = ""
  description = "Name of the bucket we use to export data to data.gov.uk"
}

variable "use_env_prefix" {

}

variable "backup_mysql_rds" {
  description = "Whether or not to create objects to and make backups of MySQL RDS data"
  default     = false
  type        = bool
}

variable "low_cpu_threshold" {
  description = "Low CPU threshold for ECS task alarms. This value is higher (1%) for production but lower (0.3%) for staging and is based on average CPU."
  type        = number
}

variable "is_production_aws_account" {
}

variable "rds_mysql_backup_bucket" {
}
