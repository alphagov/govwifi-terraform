# Cyber has requested we add these

variable "staging_log_group_names" {
  type = list(string)
  default = [
    "staging-database-backup-log-group",
    "staging-database-backup-log-group",
    "staging-bastion/var/log/auth.log",
    "staging-bastion/var/log/cloud-init-output.log",
    "staging-bastion/var/log/dmesg",
    "staging-bastion/var/log/syslog",
    "staging-bastion/var/log/unattended-upgrades/unattended-upgrades.log"
  ]
}

resource "aws_cloudwatch_log_subscription_filter" "log_subscription" {
  count = var.env_name == "staging" ? length(var.staging_log_group_names) : 0

  name            = "log_subscription_${count.index}"
  log_group_name  = element(var.staging_log_group_names, count.index)
  filter_pattern  = ""
  destination_arn = "arn:aws:logs:eu-west-2:${var.cyber_account_id}:destination:csls_cw_logs_destination_prod"
}
