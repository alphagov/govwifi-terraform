resource "aws_iam_role" "govwifi-wifi-london-aws-chatbot-role" {
  name        = "govwifi-aws-chatbot-role"
  path        = "/"
  description = "Role to enable Amazon Chatbot to function."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "chatbot.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_cloudformation_stack" "aws-slack-chatbot" {
  name = "govwifi-monitoring-chat-configuration"

  template_body = <<-STACK
  {
    "Resources": {
      "GovwifiSlackChatbot": {
      "Type" : "AWS::Chatbot::SlackChannelConfiguration",
      "Properties" : {
          "ConfigurationName" : "govwifi-monitoring-chat-configuration",
          "IamRoleArn" : "${aws_iam_role.govwifi-wifi-london-aws-chatbot-role.arn}",
          "LoggingLevel" : "NONE",
          "SlackChannelId" : "${local.slack-channel-id}",
          "SlackWorkspaceId" : "${local.slack-workplace-id}",
          "SnsTopicArns" : [ "${var.critical-notifications-topic-arn}","${var.capacity-notifications-topic-arn}","${var.route53-critical-notifications-topic-arn}" ]
        }
      }
    }
  }
  STACK
}
