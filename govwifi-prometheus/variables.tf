variable "env_name" {
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

variable "frontend_vpc_id" {
}

variable "ssh_key_name" {
}

variable "fe_admin_in" {
}

variable "fe_ecs_out" {
}

variable "fe_radius_in" {
}

variable "fe_radius_out" {
}

variable "london_radius_ip_addresses" {
  type    = list(string)
  default = []
}

variable "dublin_radius_ip_addresses" {
  type    = list(string)
  default = []
}

