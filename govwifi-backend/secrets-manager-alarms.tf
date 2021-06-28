#
// This has been applied in staging
resource "aws_cloudwatch_event_rule" "secretmanager_putsecretvalue_rule" {
  count       = 1
  name        = "${var.env}-PutSecretValue-Alarm"
  description = "Monitor when a user creates a new version of the secret with new encrypted data."

  event_pattern = <<EOF
{
  "EventName": [ "PutSecretValue" ]
}
EOF

}

resource "aws_cloudwatch_event_target" "secretmanager_putsecretvalue_sns" {
  rule      = aws_cloudwatch_event_rule.secretmanager_putsecretvalue_rule[0].name
  target_id = "SendToSNS"
  arn       = var.critical-notifications-arn
}

// TODO: create a CloudWatch alarm for PutSecretValue, DeleteSecret, UpdateSecret, and CreateSecret
// Click-ops example is AttemptsToAccessDeletedSecretsAlarm which is based on
// this documentation: https://docs.aws.amazon.com/secretsmanager/latest/userguide/monitoring.html#monitoring_cloudwatch_deleted-secrets_part1

resource "aws_cloudwatch_log_group" "secrets_manager_cloudtrail_log_group" {
  name = "CloudTrail/MyCloudWatchLogGroup" // TODO: rename
}

// Imported from click-ops resource
resource "aws_cloudtrail" "secrets_management_events" {
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.secrets_manager_cloudtrail_log_group.arn
  cloud_watch_logs_role_arn     = "arn:aws:iam::${var.aws-account-id}:role/CloudTrail_CloudWatchLogs_Role"
  enable_log_file_validation    = true
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false
  kms_key_id                    = "arn:aws:kms:${var.aws-region}:${var.aws-account-id}:alias/kms-cloudtrail-logs-manangement-events"
  name                          = "management-events"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_management.id
}


// Imported from click-ops resource
resource "aws_s3_bucket" "cloudtrail_management" {
  bucket = "aws-cloudtrail-logs-${var.aws-account-id}-management-events"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:${var.aws-region}:${var.aws-account-id}:alias/kms_cloudtrail_logs_manangement_events"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_management_policy" {
  bucket = "aws-cloudtrail-logs-${var.aws-account-id}-management-events"
  policy = jsonencode(
  {
    Statement = [
      {
        Action    = "s3:GetBucketAcl"
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Resource  = "arn:aws:s3:::aws-cloudtrail-logs-${var.aws-account-id}-management-events"
        Sid       = "AWSCloudTrailAclCheck20150319"
      },
      {
        Action    = "s3:PutObject"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Resource  = "arn:aws:s3:::aws-cloudtrail-logs-${var.aws-account-id}-management-events/AWSLogs/788375279931/*"
        Sid       = "AWSCloudTrailWrite20150319"
      },
    ]
    Version   = "2012-10-17"
  }
  )
}