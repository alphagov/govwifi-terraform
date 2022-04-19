variable "ssh_key_name" {
  type    = string
  default = "staging-ec2-instances-20200717"
}

variable "notify_ips" {
}

# Secrets

variable "public_google_api_key" {
  type    = string
  default = "xxxxxxxxxxxxxxxxxxxxx"
}

variable "zendesk_api_user" {
  type        = string
  description = "Username for authenticating with Zendesk API"
}

variable "notification_email" {
}
