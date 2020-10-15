# S3 bucket to store the emails
resource "aws_s3_bucket" "emailbucket" {
  bucket        = "${var.Env-Name}-emailbucket"
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
        "Resource": "arn:aws:s3:::${var.Env-Name}-emailbucket/*",
        "Condition": {
          "StringEquals": {
            "aws:Referer": "${var.aws-account-id}"
          }
        }
    },{
            "Sid": "S3PolicyStmt-DO-NOT-MODIFY",
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.Env-Name}-emailbucket/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.aws-account-id}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:s3:::${var.Env-Name}-emailbucket"
                }
            }
    }]
}
EOF

  tags = {
    Name   = "${title(var.Env-Name)} Email Bucket"
    Region = "${title(var.aws-region-name)}"

    #   Product     = "${var.product-name}"
    Environment = "${title(var.Env-Name)}"
    Category    = "User emails"
  }

  logging {
    target_bucket = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs"
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
resource "aws_s3_bucket" "admin-emailbucket" {
  bucket        = "${var.Env-Name}-admin-emailbucket"
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
        "Resource": "arn:aws:s3:::${var.Env-Name}-admin-emailbucket/*",
        "Condition": {
          "StringEquals": {
            "aws:Referer": "${var.aws-account-id}"
          }
        }
    },{
            "Sid": "S3PolicyStmt-DO-NOT-MODIFY",
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.Env-Name}-admin-emailbucket/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.aws-account-id}",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:s3:::${var.Env-Name}-admin-emailbucket"
                }
            }
    }]
}
EOF

  tags = {
    Name   = "${title(var.Env-Name)} Admin Email Bucket"
    Region = "${title(var.aws-region-name)}"

    #   Product     = "${var.product-name}"
    Environment = "${title(var.Env-Name)}"
    Category    = "Admin emails"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${lower(var.product-name)}-${var.Env-Name}-${lower(var.aws-region-name)}-accesslogs"
    target_prefix = "admin-emails"
  }
}

# SNS topic to notify the old backend when an email arrives
resource "aws_sns_topic" "govwifi-email-notifications" {
  name         = "${var.Env-Name}-email-notifications"
  display_name = "${title(var.Env-Name)} GovWifi email notifications"

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
      "Resource": "arn:aws:sns:${var.aws-region}:${var.aws-account-id}:${var.Env-Name}-email-notifications",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws-account-id}"
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
resource "aws_sns_topic_subscription" "email-notifications-target" {
  topic_arn                       = "${aws_sns_topic.govwifi-email-notifications.arn}"
  protocol                        = "https"
  endpoint                        = "${var.sns-endpoint}"
  endpoint_auto_confirms          = true
  confirmation_timeout_in_minutes = 2
  depends_on                      = ["aws_sns_topic.govwifi-email-notifications"]
}

# SNS topic to notify the new user-signup API when an email arrives
resource "aws_sns_topic" "user-signup-notifications" {
  name         = "${var.Env-Name}-user-signup-notifications"
  display_name = "${title(var.Env-Name)} user signup email notifications"
}

resource "aws_sns_topic_subscription" "user-signup-notifications-target" {
  topic_arn              = "${aws_sns_topic.user-signup-notifications.arn}"
  protocol               = "https"
  endpoint               = "${var.user-signup-notifications-endpoint}"
  endpoint_auto_confirms = true
  depends_on             = ["aws_sns_topic.user-signup-notifications"]
}
