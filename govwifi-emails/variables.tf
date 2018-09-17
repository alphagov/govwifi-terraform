variable "product-name" {}

variable "Env-Name" {}

variable "Env-Subdomain" {}

variable "aws-account-id" {}

variable "route53-zone-id" {}

variable "aws-region" {}

variable "aws-region-name" {}

variable "mail-exchange-server" {}

variable "sns-endpoint" {}

variable "user-signup-notifications-endpoint" {
  description = "HTTP endpoint used by SNS to send user signup email notifications"
}

variable "devops-notifications-arn" {}

variable "support-email" {}

variable "log-request-bounce-message" {}
