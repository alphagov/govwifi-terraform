variable "bastion-server-IP" {}

# =============================
variable "administrator-IPs" {}

# Also used for the new site setup PDF - unless overridden in main.tf
variable "frontend-radius-IPs" {}

# The frontend RADIUS IPs for the current region - used for EIP association
variable "frontend-region-IPs" {}

variable "backend-subnet-IPs" {}
