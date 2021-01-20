variable "Env-Name" {}

variable "aws-region" {}

variable "zone-subnets" {
  default = {
    zone0 = "10.102.1.0/24"
    zone1 = "10.102.2.0/24"
    zone2 = "10.102.3.0/24"
  }
}

variable "prometheus_volume_size" {
  default = "40"
}

variable "prometheus-IPs" {}

variable "frontend-vpc-id" {}

variable "ssh-key-name" {}

variable "fe-admin-in" {}

variable "fe-ecs-out" {}

variable "fe-radius-in" {}

variable "fe-radius-out" {}

variable "wifi-frontend-subnet" {
  type = "list"
}

variable "radius-ip-addresses" {
  type    = "list"
  default = []
}

# Feature toggle to create (1) or not create (0) Prometheus server
# Default value is 0, we only want Prometheus enabled in Staging and Production (London only).
# To enable Prometheus, set the value to 1 in the relevant <environment>/main.tf
variable "create_prometheus_server" {
  default = 0
}

variable "london-radius-ip-addresses" {
  type    = "list"
  default = []
}

variable "dublin-radius-ip-addresses" {
  type    = "list"
  default = []
}
