// Only applied  in wifi-london so it can be used govwifi-backend/secrets-manager-alarms.tf
// We only need one KMS key for the CloudTrail logs
resource "aws_kms_key" "kms_cloudtrail_logs_manangement_events" {
  count                   = var.is_production_aws_account ? 1 : 0
  description             = "This key is used to encrypt Secrets Management CloudTrail logs"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "cloudtrail_secrets_management_alias" {
  count         = var.is_production_aws_account ? 1 : 0
  name          = "alias/kms-cloudtrail-logs-manangement-events"
  target_key_id = aws_kms_key.kms_cloudtrail_logs_manangement_events.key_id
}
