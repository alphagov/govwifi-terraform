variable "Env-Name" {
  description = "E.g. staging"
}

variable "Env-Subdomain" {
  description = "E.g. staging.wifi"
}

variable "aws-region" {
  description = "E.g. eu-west-2"
}

variable "aws-region-name" {
  description = "E.g. London"
}

variable "subnet-ids" {
  description = "List of AWS subnet IDs to place the EC2 instances and ELB into"
  type        = list(string)
}

variable "users" {
  description = "List of users to be added to the EC2 instance"
  type        = list(string)
}

variable "ami" {
  description = "AMI id to launch, must be in the region specified by the region variable"
}

variable "ecr-repository-count" {
  description = "Whether or not to create ECR repository"
  default     = 0
}

variable "ecs-service-role" {
}

variable "ecs-instance-profile-id" {
}

variable "rack-env" {
  description = "E.g. staging"
}

variable "sentry-current-env" {
  description = "The environment that Sentry will log errors to: e.g. staging"
}

variable "ssh-key-name" {
  description = "SSH key applied to the EC2 instance"
}

variable "vpc-id" {
  description = "VPC ID used for placing the ALB into"
}

variable "min-size" {
  description = "Minimum number of EC2 hosts"
}

variable "instance-count" {
  description = "Number of EC2 hosts and ECS containers to be running"
}

variable "admin-docker-image" {
  description = "Docker image URL pointing to the admin platform application"
}

variable "health_check_grace_period" {
  default     = "300"
  description = "Time after instance comes into service before checking health"
}

variable "critical-notifications-arn" {
}

variable "capacity-notifications-arn" {
}

variable "notification_arn" {
  description = "Notification ARN for alerts. In production alerts are sent to PagerDuty, but in staging alerts are sent to an email group."
  type        = string
}

variable "db-instance-count" {
}

variable "admin-db-user" {
}

variable "db-backup-retention-days" {
}

variable "db-encrypt-at-rest" {
}

variable "db-instance-type" {
}

variable "db-monitoring-interval" {
}

variable "db-storage-gb" {
}

variable "db-maintenance-window" {
}

variable "db-backup-window" {
}

variable "rds-monitoring-role" {
}

variable "london-radius-ip-addresses" {
  type = list(string)
}

variable "dublin-radius-ip-addresses" {
  type = list(string)
}

variable "sentry-dsn" {
}

variable "logging-api-search-url" {
}

variable "rr-db-host" {
}

variable "rr-db-name" {
}

variable "user-db-host" {
}

variable "user-db-name" {
}

variable "zendesk-api-endpoint" {
}

variable "zendesk-api-user" {
}

variable "public-google-api-key" {
}

variable "bastion_server_ip" {
}

variable "use_env_prefix" {
}

variable "is_production_aws_account" {
}
