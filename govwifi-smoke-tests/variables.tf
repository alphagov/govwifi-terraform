variable "aws_account_id" {
}

variable "aws_region" {
}

variable "env" {
}

variable "env_subdomain" {
}

variable "smoketests_vpc_cidr" {
}

variable "smoketest_subnet_private_a" {
}

variable "smoketest_subnet_private_b" {
}

variable "smoketest_subnet_public_a" {
}

variable "smoketest_subnet_public_b" {
}

variable "create_slack_alert" {
}

variable "govwifi_phone_number" {
}

variable "radius_ip_addresses" {
  description = "List of all external radius IP addresses"
  type        = list(string)
}