# Unless there is a default provided, all values are inherited from the main deployment file.
# Values can also be overwritten from the main deployment file.

variable "Env-Name" {
  description = "Environment name for the component."
  type        = "string"
}

variable "Env-Subdomain" {
  description = "E.g. grafana.staging.wifi"
}

variable "aws-region" {
  description = "AWS region for the component."
  type        = "string"
}

variable "ssh-key-name" {
  description = "The SSH key name to use."
  type        = "string"
}

variable "backend-subnet-ids" {
  description = "List of AWS subnet IDs to place the EC2 instances and ELB into."
  type        = "list"
}

variable "be-admin-in" {
  description = "The relevant security group for this component."
  type        = "string"
}

variable "create_grafana_server" {
  description = "A feature toggle for the Grafana instance (1 = enabled; value defaults to disabled and is overwritten in the main deployment file.)"
  default     = "0"
}

variable "vpc-id" {
  description = "VPC ID used for the Application Load Balancer."
  type        = "string"
}

variable "bastion-ips" {
  description = "The list of allowed hosts to connect to the EC2 instances."
  type        = "list"
  default     = []
}

variable "subnet-ids" {
  description = "List of AWS subnet IDs to place the EC2 instances and ELB into"
  type        = "list"
}

variable "grafana-admin" {
  description = "Credential used for Grafana Admin user"
  type        = "string"
}

variable "google-client-secret" {
  description = "Credential used for Single Sign On"
  type        = "string"
}

variable "google-client-id" {
  description = "Credential used for Single Sign On"
  type        = "string"
}

variable "create_staging_route53_record" {}
