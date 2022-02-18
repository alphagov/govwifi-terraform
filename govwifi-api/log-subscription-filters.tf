# Cyber has requested we add these

variable "staging_log_group_names" {
  type = list(string)
  default = [
    "staging-authorisation-api-docker-log-group",
    "staging-logging-api-docker-log-group",
    "staging-user-signup-api-docker-log-group",
    "/aws/rds/instance/wifi-staging-user-db/error",
    "/aws/rds/instance/wifi-staging-user-db/slowquery",
    "/aws/rds/instance/wifi-staging-db/audit",
    "/aws/rds/instance/wifi-staging-db/error",
    "/aws/rds/instance/wifi-staging-db/slowquery"
  ]
}

resource "aws_cloudwatch_log_subscription_filter" "log_subscription" {
  count = var.env_name == "staging" ? length(var.staging_log_group_names) : 0

  name            = "log_subscription_${count.index}"
  log_group_name  = element(var.staging_log_group_names, count.index)
  filter_pattern  = ""
  destination_arn = "arn:aws:logs:eu-west-2:${var.cyber_account_id}:destination:csls_cw_logs_destination_prod"
}
