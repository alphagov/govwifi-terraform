variable "Env-Name" {
}

variable "Env-Subdomain" {
}

variable "route53-zone-id" {
}

variable "vpc-cidr-block" {
}

variable "aws-region" {
}

variable "aws-region-name" {
}

variable "zone-count" {
}

variable "zone-names" {
  type = map(string)
}

variable "zone-subnets" {
  type = map(string)
}

variable "radius-instance-count" {
}

variable "radius-instance-sg-ids" {
  type = list(string)
}

variable "frontend-docker-image" {
}

variable "raddb-docker-image" {
}

variable "ami" {
  description = "AMI id to launch, must be in the region specified by the region variable"
}

variable "ssh-key-name" {
}

variable "dns-numbering-base" {
}

variable "logging-api-base-url" {
}

variable "auth-api-base-url" {
}

variable "elastic-ip-list" {
  type = list(string)
}

variable "enable-detailed-monitoring" {
}

variable "radiusd-params" {
  default = "-X"
}

variable "users" {
  type = list(string)
}

variable "rack-env" {
  default = ""
}

variable "create-ecr" {
  description = "Whether or not to create ECR repository"
  default     = 0
}

variable "bastion-ips" {
  description = "The list of allowed hosts to connect to the ec2 instances"
  type        = list(string)
  default     = []
}

variable "route53-critical-notifications-arn" {
  type = string
}

variable "devops-notifications-arn" {
  type = string
}

variable "admin-bucket-name" {
  type = string
}

variable "radius-CIDR-blocks" {
  description = "IP addresses for the London and Ireland Radius instances in CIDR block format"
  type        = list(string)
}

variable "prometheus-IP-london" {
}

variable "prometheus-IP-ireland" {
}

variable "use_env_prefix" {
}
