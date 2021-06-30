// TODO: create a CloudWatch alarm for PutSecretValue, DeleteSecret, UpdateSecret, and CreateSecret
// Click-ops example is AttemptsToAccessDeletedSecretsAlarm which is based on
// this documentation: https://docs.aws.amazon.com/secretsmanager/latest/userguide/monitoring.html#monitoring_cloudwatch_deleted-secrets_part1

data "aws_iam_role" "cloudtrail_cloudwatch_logs_role" {
  name = "CloudTrail_CloudWatchLogs_Role"
}

resource "aws_cloudtrail" "management-events" {
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.management_events_logs.arn
  cloud_watch_logs_role_arn     = data.aws_iam_role.cloudtrail_cloudwatch_logs_role.arn
  enable_log_file_validation    = true
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false
  kms_key_id                    = aws_kms_key.cloudtrail_management_kms_key.arn
  name                          = "secrets-management-events"
  s3_bucket_name                = aws_s3_bucket.management-events.id
  tags                          = {
    "Service" = "Test"
  }
}

resource "aws_s3_bucket" "management-events" {
  bucket                      = "aws-cloudtrail-logs-${var.aws-account-id}-secrets-manangement-events"
  region                      = var.aws-region
  request_payer               = "BucketOwner"
  acl                         = "private"
  force_destroy               = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.cloudtrail_management_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket_policy" "management-events" {
  bucket = aws_s3_bucket.management-events.id

  policy = jsonencode(
  {
    Statement = [
      {
        Action    = "s3:GetBucketAcl"
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Resource  = aws_s3_bucket.management-events.arn
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
        Resource  = "${aws_s3_bucket.management-events.arn}/AWSLogs/${var.aws-account-id}/*"
        Sid       = "AWSCloudTrailWrite20150319"
      },
    ]
    Version   = "2012-10-17"
  })
}

resource "aws_cloudwatch_log_group" "management_events_logs" {
  name              = "aws-cloudtrail-logs-${var.aws-account-id}-secrets-manangement-events"
  retention_in_days = 0
}

resource "aws_kms_key" "cloudtrail_management_kms_key" {
  description         = "The key created by CloudTrail to encrypt log files relating to management events"
  enable_key_rotation = false
  is_enabled          = true
  key_usage           = "ENCRYPT_DECRYPT"
}

resource "aws_kms_alias" "cloudtrail_management_alias" {
  name          = "alias/${var.aws-region}-kms-cloudtrail-logs-secrets-manangement-events"
  target_key_id = aws_kms_key.cloudtrail_management_kms_key.key_id
}