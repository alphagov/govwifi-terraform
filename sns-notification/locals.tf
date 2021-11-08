locals {
  enable_emails = length(var.emails) > 0 ? 1 : 0
}

