locals {
  enable-emails = length(var.emails) > 0 ? 1 : 0
}

