variable "create_production_bastion_key" {
  description = "Feature toggle key generation based on environment. Value should be 0 for staging and 1 for production."
  type        = number
}

variable "govwifi_bastion_key_name" {
  description = "Name of the SSH key for the Bastion instance in AWS."
  type        = string
}

variable "govwifi_bastion_key_pub" {
  description = "SSH public key for the Bastion instance."
  type        = string
}

variable "govwifi_key_name" {
  description = "Name of the SSH key for the frontend RADIUS instances in AWS."
  type        = string
}

variable "govwifi_key_name_pub" {
  description = "SSH public key for the frontend RADIUS instances."
  type        = string
}
