variable "Env-Name" {}

variable "aws-region" {
  default = "eu-west-2a"
}

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

variable "prometheus_eip" {
    default = "18.135.11.32"
}

variable "frontend-vpc-id" {}

variable "ami" {}

variable "ssh-key-name" {}

variable "fe-admin-in" {}

variable "fe-ecs-out" {}

variable "fe-radius-in" {}

variable "fe-radius-out" {}

variable "ecs-instance-profile" {}

variable "wifi-frontend-subnet" {
  type = "list"
}

variable "london-radius-ip-addresses" {
  type = "list"
  //default = ["52.56.75.60", "52.56.49.122", "3.9.74.198"]
}
