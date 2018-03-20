variable "cluster_name" {
  description = "The name of the ECS Cluster"
}

variable "ami" {}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "region" {
  default     = "eu-west-1"
  description = "The region of AWS"
}

variable "availability_zones" {
  description = "Comma separated list of EC2 availability zones to launch instances, must be within region"
}

variable "subnet_ids" {
  description = "Comma separated list of subnet ids, must match availability zones"
}

variable "security_group_ids" {
  description = "Comma separated list of security group ids"
  default     = ""
}

variable "instance_type" {
  description = "Name of the AWS instance type"
}

variable "backend-cpualarm-count" {}

variable "min_size" {
  default     = "1"
  description = "Minimum number of instances to run in the group"
}

variable "max_size" {
  default     = "6"
  description = "Maximum number of instances to run in the group"
}

variable "desired_capacity" {
  default     = "3"
  description = "Desired number of instances to run in the group"
}

variable "health_check_grace_period" {
  default     = "300"
  description = "Time after instance comes into service before checking health"
}

variable "instance-profile-id" {
  description = "The IAM Instance Profile (e.g. right side of Name=AmazonECSContainerInstanceRole)"
}

variable "Env-Name" {}

variable "critical-notifications-arn" {}
variable "capacity-notifications-arn" {}

variable "users" {
  type = "list"
}
