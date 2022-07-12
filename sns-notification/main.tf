terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_sns_topic" "this" {
  name = var.topic_name
}

resource "aws_cloudformation_stack" "email" {
  count = local.enable_emails
  name  = "${var.topic_name}-subscriptions"

  template_body = jsonencode({
    "Resources" = {
      for email in var.emails : sha256("${var.topic_name}-${email}") => {
        "Type" = "AWS::SNS::Subscription",
        "Properties" = {
          "Endpoint" = email,
          "Protocol" = "email",
          "TopicArn" = aws_sns_topic.this.arn
        }
      }
    }
  })
}