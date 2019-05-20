variable "environment" {
  default     = {}
  type        = "map"
  description = "Environment Variables for the task"
}

variable "stage" {
  description = "the deployment stage name, e.g. staging, production"
  type        = "string"
}

variable "namespace" {
  description = "the namespace to group resources under"
  type        = "string"
  default     = "govwifi"
}

variable "name" {
  type        = "string"
  description = "Used to construct service, cluster, and container names"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "tags to set on created resources"
}

variable "cluster-id" {
  type        = "string"
  default     = ""
  description = "Associate service to an already created cluster"
}

variable "count-per-subnet" {
  type        = "string"
  default     = "1"
  description = "amount of tasks to launch in each subnet."
}

variable "cpu" {
  type    = "string"
  default = "256"
}

variable "memory" {
  type    = "string"
  default = "512"
}

variable "ports" {
  type        = "map"
  default     = {}
  description = "A map of {port: protocol} to open for the tasks"
}

variable "repository" {
  type        = "string"
  default     = ""
  description = "The repository to fetch the image from. Leave unset to create a new repository."
}

variable "image-tag" {
  type        = "string"
  default     = "latest"
  description = "the Container Image tag to launch the task with."
}

variable "vpc-id" {
  type        = "string"
  description = "VPC to run the service in"
}

variable "subnet-ids" {
  type        = "list"
  default     = []
  description = "Subnet IDs. Defaults to using all public subnets in the provided VPC"
}

variable "loadbalancer-arn" {
  type        = "string"
  default     = ""
  description = "Set this to manage your own loadbalancer and listeners. Otherwise, creates a loadbalancer."
}

variable "public-loadbalancer" {
  default     = true
  description = "When creating the loadbalancer, make it publicly available on the internet"
}
