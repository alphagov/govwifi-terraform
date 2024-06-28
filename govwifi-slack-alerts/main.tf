terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    awscc = {
      source = "hashicorp/awscc"
    }
  }
}

resource "aws_iam_role" "govwifi_wifi_london_aws_chatbot_role" {
  count       = var.create_slack_alert
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

resource "awscc_chatbot_slack_channel_configuration" "aws_slack_alert_chatbot" {
  count              = var.create_slack_alert
  configuration_name = "govwifi-chatbot-alert-configuration"
  iam_role_arn       = aws_iam_role.govwifi_wifi_london_aws_chatbot_role[0].arn
  slack_channel_id   = local.slack_alerts_channel_id
  slack_workspace_id = local.slack_workplace_id
  sns_topic_arns     = [var.london_critical_notifications_topic_arn, var.dublin_critical_notifications_topic_arn, var.route53_critical_notifications_topic_arn]
}

resource "awscc_chatbot_slack_channel_configuration" "aws_slack_monitor_chatbot" {
  count              = var.create_slack_alert
  configuration_name = "govwifi-slack-chatbot-monitoring-configuration"
  iam_role_arn       = aws_iam_role.govwifi_wifi_london_aws_chatbot_role[0].arn
  slack_channel_id   = local.slack_channel_id
  slack_workspace_id = local.slack_workplace_id
  sns_topic_arns     = [var.london_capacity_notifications_topic_arn, var.dublin_capacity_notifications_topic_arn]
}
