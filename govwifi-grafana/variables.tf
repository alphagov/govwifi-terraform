# Unless there is a default provided, all values are inherited from the main deployment file.
# Values can also be overwritten from the main deployment file.

variable "Env-Name" {
  description = "Environment name for the component."
  type        = string
}

variable "Env-Subdomain" {
  description = "E.g. grafana.staging.wifi"
}

variable "aws-region" {
  description = "AWS region for the component."
  type        = string
}

variable "ssh-key-name" {
  description = "The SSH key name to use."
  type        = string
}

variable "backend-subnet-ids" {
  description = "List of AWS subnet IDs to place the EC2 instances and ELB into."
  type        = list(string)
}

variable "be-admin-in" {
  description = "The relevant security group for this component."
  type        = string
}

variable "vpc-id" {
  description = "VPC ID used for the Application Load Balancer."
  type        = string
}

variable "bastion_ip" {
  description = "The IP address of the bastion machine."
  type        = string
}

variable "prometheus_ips" {
  description = "The list of allowed prometheus servers to connect to the EC2 instances on 9090."
  type        = list(string)
  default     = []
}

variable "subnet-ids" {
  description = "List of AWS subnet IDs to place the EC2 instances and ELB into"
  type        = list(string)
}

variable "administrator_ips" {
  description = "IPs associated with the GDS/CDIO VPN to allow access"
}

variable "grafana-device-name" {
  description = "Name of Grafana Persistent Drive Device Name"
  type        = string
  default     = "/dev/xvdp"
}

variable "grafana-docker-version" {
  description = "Grafana Docker Version Number"
  type        = string
  default     = "7.5.2"
}

variable "critical-notifications-arn" {
  description = "Arn of the critical-nofications sns topic"
  type        = string
}

variable "use_env_prefix" {
}

variable "is_production_aws_account" {
}
