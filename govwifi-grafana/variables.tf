variable "Env-Name" {
  description = "Environment name for the component. Value is inherited from the main deployment file."
  type        = "string"
}

variable "aws-region" {
  description = "AWS region for the component. Value is inherited from the main deployment file."
  type        = "string"
}

variable "ssh-key-name" {
  description = "The SSH key name to use. Value is inherited from the main deployment file."
  type        = "string"
}

variable "backend-subnet-ids" {
  description = "The subnets associated with the backend VPC. Values are inherited from the main deployment file."
  type        = "list"
}

variable "be-admin-in" {
  description = "The relevant security group for this component. Value is inherited from the main deployment file."
  type        = "string"
}

variable "create_grafana_server" {
  description = "A feature toggle for the Grafana instance (1 = enabled; value defaults to disabled and is overwritten in the main deployment file.)"
  default     = "0"
}
