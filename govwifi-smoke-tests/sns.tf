resource "aws_sns_topic" "smoke_tests" {
  name = "govwifi-smoke-tests"
}

resource "aws_cloudwatch_event_rule" "smoke_tests" {
  name        = "smoke-tests-notification"
  description = "Capture any failed smoke-tests and notify smoke-tests sns topic"

  event_pattern = <<EOF
{
  "source": ["aws.codebuild"],
  "detail-type": ["CodeBuild Build State Change"],
  "detail": {
    "build-status": ["FAILED"],
    "project-name": ["govwifi-smoke-tests"]
  }
}
EOF

}



resource "aws_sns_topic_policy" "smoke_tests" {
  arn = aws_sns_topic.smoke_tests.arn

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
        "SNS:Publish"
      ],
      "Resource": "arn:aws:sns:eu-west-2:${var.aws_account_id}:govwifi-smoke-tests",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_id}"
        }
      }
    },
    {
      "Sid": "eventbridgesmoke",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:eu-west-2:${var.aws_account_id}:govwifi-smoke-tests"
    },
    {
      "Sid": "AWSEvents_smoke-tests-notification_SendSmoketestsToSNS",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:eu-west-2:${var.aws_account_id}:govwifi-smoke-tests"
    }
  ]
}
EOF

}



resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.smoke_tests.name
  target_id = "SendSmoketestsToSNS"
  arn       = aws_sns_topic.smoke_tests.arn

  input_transformer {
    input_paths = {
      build-id = "$.detail.build-id",
    }

    input_template = "\"Smoke Test Failure: <build-id>\""
  }
}
