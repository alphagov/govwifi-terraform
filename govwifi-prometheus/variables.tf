variable "env_name" {
}

variable "prometheus_volume_size" {
  default = "40"
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

variable "wifi_frontend_subnet" {
  type = list(string)
}

variable "london_radius_ip_addresses" {
  type    = list(string)
  default = []
}

variable "dublin_radius_ip_addresses" {
  type    = list(string)
  default = []
}

