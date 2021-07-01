variable "create_production_bastion_key" {
  description = "Feature toggle key generation based on environment. Value should be 0 for staging and 1 for production."
  type        = number
}