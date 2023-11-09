resource "aws_iam_role" "AWSServiceRoleForAmazonGuardDuty" {
  name = "AWSServiceRoleForAmazonGuardDuty"
  path = "/aws-service-role/guardduty.amazonaws.com/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "guardduty.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForApplicationAutoScaling_ECSService" {
  name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
  path = "/aws-service-role/ecs.application-autoscaling.amazonaws.com/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.application-autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForAutoScaling" {
  name        = "AWSServiceRoleForAutoScaling"
  path        = "/aws-service-role/autoscaling.amazonaws.com/"
  description = "Default Service-Linked Role enables access to AWS Services and Resources used or managed by Auto Scaling"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForCloudTrail" {
  name = "AWSServiceRoleForCloudTrail"
  path = "/aws-service-role/cloudtrail.amazonaws.com/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForCloudWatchCrossAccount" {
  name        = "AWSServiceRoleForCloudWatchCrossAccount"
  path        = "/aws-service-role/cloudwatch-crossaccount.amazonaws.com/"
  description = "Allows CloudWatch to assume CloudWatch-CrossAccountSharing roles in remote accounts on behalf of the current account in order to display data cross-account, cross region"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudwatch-crossaccount.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForECS" {
  name        = "AWSServiceRoleForECS"
  path        = "/aws-service-role/ecs.amazonaws.com/"
  description = "Role to enable Amazon ECS to manage your cluster."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForElastiCache" {
  name        = "AWSServiceRoleForElastiCache"
  path        = "/aws-service-role/elasticache.amazonaws.com/"
  description = "Allows ElastiCache to manage AWS resources for your cache on your behalf."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticache.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForElasticLoadBalancing" {
  name        = "AWSServiceRoleForElasticLoadBalancing"
  path        = "/aws-service-role/elasticloadbalancing.amazonaws.com/"
  description = "Allows ELB to call AWS services on your behalf."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticloadbalancing.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForGlobalAccelerator" {
  name        = "AWSServiceRoleForGlobalAccelerator"
  path        = "/aws-service-role/globalaccelerator.amazonaws.com/"
  description = "Allows Global Accelerator to call AWS services on customer's behalf"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "globalaccelerator.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForOrganizations" {
  name        = "AWSServiceRoleForOrganizations"
  path        = "/aws-service-role/organizations.amazonaws.com/"
  description = "Service-linked role used by AWS Organizations to enable integration of other AWS services with Organizations."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "organizations.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForRDS" {
  name        = "AWSServiceRoleForRDS"
  path        = "/aws-service-role/rds.amazonaws.com/"
  description = "Allows Amazon RDS to manage AWS resources on your behalf"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForSecurityHub" {
  name = "AWSServiceRoleForSecurityHub"
  path = "/aws-service-role/securityhub.amazonaws.com/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "securityhub.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForSupport" {
  name        = "AWSServiceRoleForSupport"
  path        = "/aws-service-role/support.amazonaws.com/"
  description = "Enables resource access for AWS to provide billing, administrative and support services"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "support.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "AWSServiceRoleForTrustedAdvisor" {
  name        = "AWSServiceRoleForTrustedAdvisor"
  path        = "/aws-service-role/trustedadvisor.amazonaws.com/"
  description = "Access for the AWS Trusted Advisor Service to help reduce cost, increase performance, and improve security of your AWS environment."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "trustedadvisor.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "flowlogsRole" {
  name = "flowlogsRole"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "frontend_execution_role" {
  name        = "frontend-execution-role"
  path        = "/"
  description = "Allows ECS tasks to call AWS services on your behalf."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "GDSAdminAccessGovWifi" {
  name        = "GDSAdminAccessGovWifi"
  path        = "/"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::622626885786:user/mark.oloughlin@digital.cabinet-office.gov.uk",
          "AIDAIO6NIIISI5Q7XLK3A"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "SNSSuccessFeedback_oneClick_SNSSuccessFeedback_1479821088561" {
  name = "oneClick_SNSSuccessFeedback_1479821088561"
  role = "SNSSuccessFeedback"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:PutMetricFilter",
        "logs:PutRetentionPolicy"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY

}
