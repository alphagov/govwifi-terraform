variable "create_production_bastion_key" {
  description = "Feature toggle key generation based on environment. Value should be 0 for staging and 1 for production."
  type        = number
}

variable "govwifi-bastion-key-name" {
  description = "Name of the SSH key for the Bastion instance in AWS."
  type        = string
}

variable "govwifi-bastion-key-pub" {
  description = "SSH public key for the Bastion instance."
  type        = string
}

variable "govwifi-key-name" {
  description = "Name of the SSH key for the frontend RADIUS instances in AWS."
  type        = string
}

variable "govwifi-key-name-pub" {
  description = "SSH public key for the frontend RADIUS instances."
  type        = string
}
