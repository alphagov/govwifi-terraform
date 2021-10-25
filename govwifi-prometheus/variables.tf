variable "Env-Name" {
}

variable "aws-region" {
}

variable "prometheus_volume_size" {
  default = "40"
}

variable "prometheus_ip" {
  description = "The EIP of the EC2 instance"
  type        = string
}

variable "grafana_ip" {
  description = "The grafana IP allowed into prometheus servers to connect to the EC2 instances on 9090."
  type        = string
}

variable "frontend-vpc-id" {
}

variable "ssh-key-name" {
}

variable "fe-admin-in" {
}

variable "fe-ecs-out" {
}

variable "fe-radius-in" {
}

variable "fe-radius-out" {
}

variable "london_radius_ip_addresses" {
  type    = list(string)
  default = []
}

variable "dublin_radius_ip_addresses" {
  type    = list(string)
  default = []
}

