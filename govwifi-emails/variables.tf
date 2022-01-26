variable "product_name" {
}

variable "env_name" {
}

variable "env_subdomain" {
}

variable "aws_account_id" {
}

variable "route53_zone_id" {
}

variable "aws_region" {
}

variable "aws_region_name" {
}

variable "mail_exchange_server" {
}

variable "user_signup_notifications_endpoint" {
  description = "HTTP endpoint used by SNS to send user signup email notifications"
}

variable "devops_notifications_arn" {
}
