# S3 bucket to store the emails
resource "aws_s3_bucket" "emailbucket" {
  bucket        = var.is_production_aws_account ? "${var.env_name}-emailbucket" : "${var.env_subdomain}-emailbucket"
  force_destroy = true

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [{
        "Sid": "GiveSESPermissionToWriteEmail",
        "Effect": "Allow",
        "Principal": {
          "Service": "ses.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${var.is_production_aws_account ? var.env_name : var.env_subdomain}-emailbucket/*",
        "Condition": {
          "StringEquals": {
            "aws:Referer": "${var.aws_account_id}"
          }
        }
    },{
            "Sid": "S3PolicyStmt-DO-NOT-MODIFY",
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.is_production_aws_account ? var.env_name : var.env_subdomain}-emailbucket/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.aws_account_id}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:s3:::${var.is_production_aws_account ? var.env_name : var.env_subdomain}-emailbucket"
                }
            }
    }]
}
EOF


  tags = {
    Name   = "${title(var.env_name)} Email Bucket"
    Region = title(var.aws_region_name)
    #   Product     = "${var.product_name}"
    Environment = title(var.env_name)
    Category    = "User emails"
  }

  logging {
    target_bucket = "${lower(var.product_name)}-${var.env_name}-${lower(var.aws_region_name)}-accesslogs"
    target_prefix = "user-emails"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      days = 1
    }
  }
}

# S3 bucket to store administration emails - mostly set up so we can receive
# emails regards to the AWS-provided certificate(used for the elb) approval process.
resource "aws_s3_bucket" "admin_emailbucket" {
  bucket        = "${var.env_name}-admin-emailbucket"
  force_destroy = true

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [{
        "Sid": "GiveSESPermissionToWriteEmail",
        "Effect": "Allow",
        "Principal": {
          "Service": "ses.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${var.env_name}-admin-emailbucket/*",
        "Condition": {
          "StringEquals": {
            "aws:Referer": "${var.aws_account_id}"
          }
        }
    },{
            "Sid": "S3PolicyStmt-DO-NOT-MODIFY",
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.env_name}-admin-emailbucket/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.aws_account_id}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:s3:::${var.env_name}-admin-emailbucket"
                }
            }
    }]
}
EOF


  tags = {
    Name   = "${title(var.env_name)} Admin Email Bucket"
    Region = title(var.aws_region_name)
    #   Product     = "${var.product_name}"
    Environment = title(var.env_name)
    Category    = "Admin emails"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${lower(var.product_name)}-${var.env_name}-${lower(var.aws_region_name)}-accesslogs"
    target_prefix = "admin-emails"
  }
}

# SNS topic to notify the old backend when an email arrives
resource "aws_sns_topic" "govwifi_email_notifications" {
  name         = "${var.env_name}-email-notifications"
  display_name = "${title(var.env_name)} GovWifi email notifications"

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:${var.aws_region}:${var.aws_account_id}:${var.env_name}-email-notifications",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_id}"
        }
      }
    }
  ]
}
EOF


  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 0,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false
  }
}
EOF

}

# Subscription
resource "aws_sns_topic_subscription" "email_notifications_target" {
  count                           = var.is_production_aws_account ? 1 : 0
  topic_arn                       = aws_sns_topic.govwifi_email_notifications.arn
  protocol                        = "https"
  endpoint                        = var.sns_endpoint
  endpoint_auto_confirms          = true
  confirmation_timeout_in_minutes = 2
  depends_on                      = [aws_sns_topic.govwifi_email_notifications]
}

# SNS topic to notify the new user-signup API when an email arrives
resource "aws_sns_topic" "user_signup_notifications" {
  name         = "${var.env_name}-user-signup-notifications"
  display_name = "${title(var.env_name)} user signup email notifications"
}

resource "aws_sns_topic_subscription" "user_signup_notifications_target" {
  topic_arn              = aws_sns_topic.user_signup_notifications.arn
  protocol               = "https"
  endpoint               = var.user_signup_notifications_endpoint
  endpoint_auto_confirms = true
  depends_on             = [aws_sns_topic.user_signup_notifications]
}
