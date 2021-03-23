# resource "aws_sns_topic" "govwifi-monitoring-slack" {
#   name         = "govwifi-monitoring-slack"
#   display_name = "GovWifi Monoitoring Slack Alerts"
#
#   policy = <<EOF
# {
#   "Version": "2008-10-17",
#   "Id": "__default_policy_ID",
#   "Statement": [
#     {
#       "Sid": "__default_statement_ID",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "*"
#       },
#       "Action": [
#         "SNS:Publish",
#         "SNS:RemovePermission",
#         "SNS:SetTopicAttributes",
#         "SNS:DeleteTopic",
#         "SNS:ListSubscriptionsByTopic",
#         "SNS:GetTopicAttributes",
#         "SNS:Receive",
#         "SNS:AddPermission",
#         "SNS:Subscribe"
#       ],
#       "Resource": "arn:aws:sns:${var.aws-region}:${var.aws-account-id}:govwifi-monitoring-slack",
#       "Condition": {
#         "StringEquals": {
#           "AWS:SourceOwner": "${var.aws-account-id}"
#         }
#       }
#     },
#     {
#       "Sid": "__console_sub_0",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::${var.aws-account-id}:root"
#       },
#       "Action": [
#         "SNS:Subscribe",
#         "SNS:Receive"
#       ],
#       "Resource": "arn:aws:sns:${var.aws-region}:${var.aws-account-id}:govwifi-monitoring-slack"
#     }
#   ]
# }
# EOF
#
#   delivery_policy = <<EOF
# {
#   "http": {
#     "defaultHealthyRetryPolicy": {
#       "numRetries": 3,
#       "numNoDelayRetries": 0,
#       "minDelayTarget": 20,
#       "maxDelayTarget": 20,
#       "numMinDelayRetries": 0,
#       "numMaxDelayRetries": 0,
#       "backoffFunction": "linear"
#     },
#     "disableSubscriptionOverrides": false
#   }
# }
# EOF
# }
#
# Test Subscription To Delete
# resource "aws_sns_topic_subscription" "govwifi-awschatbot-subscription-to-sns" {
#   topic_arn                       = "${aws_sns_topic.govwifi-monitoring-slack.arn}"
#   protocol                        = "https"
#   endpoint                        = "${var.govwifi-monitoring-chatbot-endpoint}"
#   depends_on                      = ["aws_sns_topic.govwifi-monitoring-slack"]
# }


resource "aws_sns_topic_subscription" "govwifi-awschatbot-subscription-to-sns" {
  topic_arn                       = "${var.critical_notifications_topic_arn}"
  protocol                        = "https"
  endpoint                        = "${var.govwifi-monitoring-chatbot-endpoint}"
//  depends_on                      = ["module.critical-notifications.aws_sns_topic.this"]
}

///rinse and repeat above 
