resource "aws_iam_role" "admin-ecsTaskExecutionRole-production-London" {
  name = "admin-ecsTaskExecutionRole-production-London"
  path = "/"

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

resource "aws_iam_role" "admin-ecsTaskExecutionRole-staging-London" {
  name = "admin-ecsTaskExecutionRole-staging-London"
  path = "/"

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

resource "aws_iam_role" "AggregateStagingMetrics-role-gej26flk" {
  name = "AggregateStagingMetrics-role-gej26flk"
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

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

resource "aws_iam_role" "CloudTrail_CloudWatchLogs_Role" {
  name = "CloudTrail_CloudWatchLogs_Role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
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

resource "aws_iam_role" "Dublin-ecs-instance-role-staging" {
  name = "Dublin-ecs-instance-role-staging"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "Dublin-ecs-instance-role-wifi" {
  name = "Dublin-ecs-instance-role-wifi"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "Dublin-ecs-service-role-staging" {
  name = "Dublin-ecs-service-role-staging"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
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

resource "aws_iam_role" "Dublin-ecs-service-role-wifi" {
  name = "Dublin-ecs-service-role-wifi"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
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

resource "aws_iam_role" "Dublin-frontend-ecs-instance-role-staging" {
  name = "Dublin-frontend-ecs-instance-role-staging"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "Dublin-frontend-ecs-instance-role-wifi" {
  name = "Dublin-frontend-ecs-instance-role-wifi"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "Dublin-frontend-ecs-task-role-staging" {
  name = "Dublin-frontend-ecs-task-role-staging"
  path = "/"

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

resource "aws_iam_role" "Dublin-frontend-ecs-task-role-wifi" {
  name = "Dublin-frontend-ecs-task-role-wifi"
  path = "/"

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

resource "aws_iam_role" "Dublin-staging-rds-monitoring-role" {
  name = "Dublin-staging-rds-monitoring-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "Dublin-wifi-backend-bastion-instance-role" {
  name = "Dublin-wifi-backend-bastion-instance-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "Dublin-wifi-rds-monitoring-role" {
  name = "Dublin-wifi-rds-monitoring-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "ecsTaskExecutionRole-production-dublin" {
  name = "ecsTaskExecutionRole-production-dublin"
  path = "/"

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

resource "aws_iam_role" "ecsTaskExecutionRole-production-London" {
  name = "ecsTaskExecutionRole-production-London"
  path = "/"

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

resource "aws_iam_role" "ecsTaskExecutionRole-staging-Dublin" {
  name = "ecsTaskExecutionRole-staging-Dublin"
  path = "/"

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

resource "aws_iam_role" "ecsTaskExecutionRole-staging-London" {
  name = "ecsTaskExecutionRole-staging-London"
  path = "/"

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

resource "aws_iam_role" "frontend-execution-role" {
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

resource "aws_iam_role" "govwifi-staging-dublin-accesslogs-replication-role" {
  name = "govwifi-staging-dublin-accesslogs-replication-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "govwifi-staging-dublin-tfstate-replication-role" {
  name = "govwifi-staging-dublin-tfstate-replication-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "govwifi-staging-london-accesslogs-replication-role" {
  name = "govwifi-staging-london-accesslogs-replication-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "govwifi-staging-london-tfstate-replication-role" {
  name = "govwifi-staging-london-tfstate-replication-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "govwifi-wifi-dublin-accesslogs-replication-role" {
  name = "govwifi-wifi-dublin-accesslogs-replication-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "govwifi-wifi-dublin-tfstate-replication-role" {
  name = "govwifi-wifi-dublin-tfstate-replication-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "govwifi-wifi-london-accesslogs-replication-role" {
  name = "govwifi-wifi-london-accesslogs-replication-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "govwifi-wifi-london-tfstate-replication-role" {
  name = "govwifi-wifi-london-tfstate-replication-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "GovWifiMetricsAggregationPrototype-role-ayhlh17x" {
  name = "GovWifiMetricsAggregationPrototype-role-ayhlh17x"
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "ITHC-RO-SecAud-Access" {
  name                 = "ITHC-RO-SecAud-Access"
  path                 = "/"
  permissions_boundary = "arn:aws:iam::aws:policy/ReadOnlyAccess"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.aws-account-id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
      }
    }
  ]
}
POLICY

}

resource "aws_iam_role" "London-ecs-admin-instance-role-staging" {
  name = "London-ecs-admin-instance-role-staging"
  path = "/"

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

resource "aws_iam_role" "London-ecs-admin-instance-role-wifi" {
  name = "London-ecs-admin-instance-role-wifi"
  path = "/"

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

resource "aws_iam_role" "London-ecs-instance-role-staging" {
  name = "London-ecs-instance-role-staging"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "London-ecs-instance-role-wifi" {
  name = "London-ecs-instance-role-wifi"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "London-ecs-service-role-staging" {
  name = "London-ecs-service-role-staging"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
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

resource "aws_iam_role" "London-ecs-service-role-wifi" {
  name = "London-ecs-service-role-wifi"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
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

resource "aws_iam_role" "London-frontend-ecs-instance-role-staging" {
  name = "London-frontend-ecs-instance-role-staging"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "London-frontend-ecs-instance-role-wifi" {
  name = "London-frontend-ecs-instance-role-wifi"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "London-frontend-ecs-task-role-staging" {
  name = "London-frontend-ecs-task-role-staging"
  path = "/"

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

resource "aws_iam_role" "London-frontend-ecs-task-role-wifi" {
  name = "London-frontend-ecs-task-role-wifi"
  path = "/"

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

resource "aws_iam_role" "London-staging-backend-bastion-instance-role" {
  name = "London-staging-backend-bastion-instance-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "London-staging-rds-monitoring-role" {
  name = "London-staging-rds-monitoring-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "London-wifi-backend-bastion-instance-role" {
  name = "London-wifi-backend-bastion-instance-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "London-wifi-rds-monitoring-role" {
  name = "London-wifi-rds-monitoring-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "NewsiteRedirect-SESEmailForwardRole-1BAO15HN9AO0C" {
  name = "NewsiteRedirect-SESEmailForwardRole-1BAO15HN9AO0C"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "rds-monitoring-role" {
  name = "rds-monitoring-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "s3crr_role_for_govwifi-staging-dublin-tfstate_to_govwifi-staging" {
  name = "s3crr_role_for_govwifi-staging-dublin-tfstate_to_govwifi-staging"
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "s3crr_role_for_govwifi-staging-ireland-accesslogs_to_govwifi-sta" {
  name = "s3crr_role_for_govwifi-staging-ireland-accesslogs_to_govwifi-sta"
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "s3crr_role_for_govwifi-staging-london-accesslogs_to_govwifi-stag" {
  name = "s3crr_role_for_govwifi-staging-london-accesslogs_to_govwifi-stag"
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "s3crr_role_for_govwifi-staging-london-tfstate_to_govwifi-staging" {
  name = "s3crr_role_for_govwifi-staging-london-tfstate_to_govwifi-staging"
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "s3crr_role_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replic" {
  name = "s3crr_role_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replic"
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "SNSSuccessFeedback" {
  name = "SNSSuccessFeedback"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "staging-logging-api-task-role" {
  name = "staging-logging-api-task-role"
  path = "/"

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

resource "aws_iam_role" "staging-logging-scheduled-task-role" {
  name = "staging-logging-scheduled-task-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "staging-safe-restart-scheduled-task-role" {
  name = "staging-safe-restart-scheduled-task-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "staging-safe-restart-task-role" {
  name = "staging-safe-restart-task-role"
  path = "/"

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

resource "aws_iam_role" "staging-user-signup-api-task-role" {
  name = "staging-user-signup-api-task-role"
  path = "/"

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

resource "aws_iam_role" "staging-user-signup-scheduled-task-role" {
  name = "staging-user-signup-scheduled-task-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "StagingMetricsAggregator-prototype-role-saci182v" {
  name = "StagingMetricsAggregator-prototype-role-saci182v"
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "test-assume-role" {
  name        = "test-assume-role"
  path        = "/"
  description = "Allows ECS tasks to call AWS services on your behalf."

  tags = {
    Service = "Test"
  }

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

resource "aws_iam_role" "test-staging-rds-role" {
  name = "test-staging-rds-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "wifi-logging-api-task-role" {
  name = "wifi-logging-api-task-role"
  path = "/"

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

resource "aws_iam_role" "wifi-logging-scheduled-task-role" {
  name = "wifi-logging-scheduled-task-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "wifi-safe-restart-scheduled-task-role" {
  name = "wifi-safe-restart-scheduled-task-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role" "wifi-safe-restart-task-role" {
  name = "wifi-safe-restart-task-role"
  path = "/"

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

resource "aws_iam_role" "wifi-user-signup-api-task-role" {
  name = "wifi-user-signup-api-task-role"
  path = "/"

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

resource "aws_iam_role" "wifi-user-signup-scheduled-task-role" {
  name = "wifi-user-signup-scheduled-task-role"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "CloudTrail_CloudWatchLogs_Role_oneClick_CloudTrail_CloudWatchLogs_Role_1510330346083" {
  name = "oneClick_CloudTrail_CloudWatchLogs_Role_1510330346083"
  role = "CloudTrail_CloudWatchLogs_Role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream20141101",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:eu-west-1:${var.aws-account-id}:log-group:CloudTrail/DefaultLogGroup:log-stream:${var.aws-account-id}_CloudTrail_eu-west-1*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents20141101",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:eu-west-1:${var.aws-account-id}:log-group:CloudTrail/DefaultLogGroup:log-stream:${var.aws-account-id}_CloudTrail_eu-west-1*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-ecs-instance-role-staging_Dublin-ecs-instance-policy-staging" {
  name = "Dublin-ecs-instance-policy-staging"
  role = "Dublin-ecs-instance-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-ecs-instance-role-wifi_Dublin-ecs-instance-policy-wifi" {
  name = "Dublin-ecs-instance-policy-wifi"
  role = "Dublin-ecs-instance-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-ecs-service-role-staging_Dublin-ecs-service-policy-staging" {
  name = "Dublin-ecs-service-policy-staging"
  role = "Dublin-ecs-service-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
      ],
      "Resource": [
        "arn:aws:elasticloadbalancing:eu-west-1:${var.aws-account-id}:loadbalancer/wifi-backend-elb-staging",
        "*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-ecs-service-role-wifi_Dublin-ecs-service-policy-wifi" {
  name = "Dublin-ecs-service-policy-wifi"
  role = "Dublin-ecs-service-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
      ],
      "Resource": [
        "arn:aws:elasticloadbalancing:eu-west-1:${var.aws-account-id}:loadbalancer/wifi-backend-elb-wifi",
        "*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-frontend-ecs-instance-role-staging_Dublin-frontend-ecs-instance-policy-staging" {
  name = "Dublin-frontend-ecs-instance-policy-staging"
  role = "Dublin-frontend-ecs-instance-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-frontend-ecs-instance-role-wifi_Dublin-frontend-ecs-instance-policy-wifi" {
  name = "Dublin-frontend-ecs-instance-policy-wifi"
  role = "Dublin-frontend-ecs-instance-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-frontend-ecs-task-role-staging_Dublin-frontend-admin-bucket-staging" {
  name = "Dublin-frontend-admin-bucket-staging"
  role = "Dublin-frontend-ecs-task-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-admin/*",
        "arn:aws:s3:::govwifi-staging-admin"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-frontend-ecs-task-role-staging_Dublin-frontend-cert-bucket-staging" {
  name = "Dublin-frontend-cert-bucket-staging"
  role = "Dublin-frontend-ecs-task-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-dublin-frontend-cert/*",
        "arn:aws:s3:::govwifi-staging-dublin-frontend-cert"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-frontend-ecs-task-role-staging_Dublin-frontend-ecs-service-policy-staging" {
  name = "Dublin-frontend-ecs-service-policy-staging"
  role = "Dublin-frontend-ecs-task-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-frontend-ecs-task-role-wifi_Dublin-frontend-admin-bucket-wifi" {
  name = "Dublin-frontend-admin-bucket-wifi"
  role = "Dublin-frontend-ecs-task-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-production-admin/*",
        "arn:aws:s3:::govwifi-production-admin"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-frontend-ecs-task-role-wifi_Dublin-frontend-cert-bucket-wifi" {
  name = "Dublin-frontend-cert-bucket-wifi"
  role = "Dublin-frontend-ecs-task-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-production-dublin-frontend-cert/*",
        "arn:aws:s3:::govwifi-production-dublin-frontend-cert"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-frontend-ecs-task-role-wifi_Dublin-frontend-ecs-service-policy-wifi" {
  name = "Dublin-frontend-ecs-service-policy-wifi"
  role = "Dublin-frontend-ecs-task-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-staging-rds-monitoring-role_Dublin-staging-rds-monitoring-policy" {
  name = "Dublin-staging-rds-monitoring-policy"
  role = "Dublin-staging-rds-monitoring-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableCreationAndManagementOfRDSCloudwatchLogGroups",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:PutRetentionPolicy"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:RDS*"
      ]
    },
    {
      "Sid": "EnableCreationAndManagementOfRDSCloudwatchLogStreams",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:RDS*:log-stream:*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-wifi-backend-bastion-instance-role_Dublin-wifi-backend-bastion-instance-policy" {
  name = "Dublin-wifi-backend-bastion-instance-policy"
  role = "Dublin-wifi-backend-bastion-instance-role"

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
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "Dublin-wifi-rds-monitoring-role_Dublin-wifi-rds-monitoring-policy" {
  name = "Dublin-wifi-rds-monitoring-policy"
  role = "Dublin-wifi-rds-monitoring-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableCreationAndManagementOfRDSCloudwatchLogGroups",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:PutRetentionPolicy"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:RDS*"
      ]
    },
    {
      "Sid": "EnableCreationAndManagementOfRDSCloudwatchLogStreams",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:RDS*:log-stream:*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "flowlogsRole_oneClick_flowlogsRole_1480343201952" {
  name = "oneClick_flowlogsRole_1480343201952"
  role = "flowlogsRole"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-ecs-admin-instance-role-staging_London-ecs-admin-instance-policy-staging" {
  name = "London-ecs-admin-instance-policy-staging"
  role = "London-ecs-admin-instance-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHealthChecks",
        "route53:GetHealthCheckStatus"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-admin/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-admin-mou/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-admin-mou"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-product-page-data/*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-ecs-admin-instance-role-wifi_London-ecs-admin-instance-policy-wifi" {
  name = "London-ecs-admin-instance-policy-wifi"
  role = "London-ecs-admin-instance-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHealthChecks",
        "route53:GetHealthCheckStatus"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-production-admin/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-production-admin-mou/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-production-admin-mou"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-production-product-page-data/*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-ecs-instance-role-staging_London-ecs-instance-policy-staging" {
  name = "London-ecs-instance-policy-staging"
  role = "London-ecs-instance-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-ecs-instance-role-wifi_London-ecs-instance-policy-wifi" {
  name = "London-ecs-instance-policy-wifi"
  role = "London-ecs-instance-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-ecs-service-role-staging_London-ecs-service-policy-staging" {
  name = "London-ecs-service-policy-staging"
  role = "London-ecs-service-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
      ],
      "Resource": [
        "arn:aws:elasticloadbalancing:eu-west-2:${var.aws-account-id}:loadbalancer/wifi-backend-elb-staging",
        "*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-ecs-service-role-wifi_London-ecs-service-policy-wifi" {
  name = "London-ecs-service-policy-wifi"
  role = "London-ecs-service-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
      ],
      "Resource": [
        "arn:aws:elasticloadbalancing:eu-west-2:${var.aws-account-id}:loadbalancer/wifi-backend-elb-wifi",
        "*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-frontend-ecs-instance-role-staging_London-frontend-ecs-instance-policy-staging" {
  name = "London-frontend-ecs-instance-policy-staging"
  role = "London-frontend-ecs-instance-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-frontend-ecs-instance-role-wifi_London-frontend-ecs-instance-policy-wifi" {
  name = "London-frontend-ecs-instance-policy-wifi"
  role = "London-frontend-ecs-instance-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-frontend-ecs-task-role-staging_London-frontend-admin-bucket-staging" {
  name = "London-frontend-admin-bucket-staging"
  role = "London-frontend-ecs-task-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-admin/*",
        "arn:aws:s3:::govwifi-staging-admin"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-frontend-ecs-task-role-staging_London-frontend-cert-bucket-staging" {
  name = "London-frontend-cert-bucket-staging"
  role = "London-frontend-ecs-task-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-frontend-cert/*",
        "arn:aws:s3:::govwifi-staging-london-frontend-cert"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-frontend-ecs-task-role-staging_London-frontend-ecs-service-policy-staging" {
  name = "London-frontend-ecs-service-policy-staging"
  role = "London-frontend-ecs-task-role-staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-frontend-ecs-task-role-wifi_London-frontend-admin-bucket-wifi" {
  name = "London-frontend-admin-bucket-wifi"
  role = "London-frontend-ecs-task-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-production-admin/*",
        "arn:aws:s3:::govwifi-production-admin"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-frontend-ecs-task-role-wifi_London-frontend-cert-bucket-wifi" {
  name = "London-frontend-cert-bucket-wifi"
  role = "London-frontend-ecs-task-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-production-london-frontend-cert/*",
        "arn:aws:s3:::govwifi-production-london-frontend-cert"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-frontend-ecs-task-role-wifi_London-frontend-ecs-service-policy-wifi" {
  name = "London-frontend-ecs-service-policy-wifi"
  role = "London-frontend-ecs-task-role-wifi"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-staging-backend-bastion-instance-role_London-staging-backend-bastion-instance-policy" {
  name = "London-staging-backend-bastion-instance-policy"
  role = "London-staging-backend-bastion-instance-role"

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
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::staging-london-pp-data/*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-staging-rds-monitoring-role_London-staging-rds-monitoring-policy" {
  name = "London-staging-rds-monitoring-policy"
  role = "London-staging-rds-monitoring-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableCreationAndManagementOfRDSCloudwatchLogGroups",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:PutRetentionPolicy"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:RDS*"
      ]
    },
    {
      "Sid": "EnableCreationAndManagementOfRDSCloudwatchLogStreams",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:RDS*:log-stream:*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-wifi-backend-bastion-instance-role_London-wifi-backend-bastion-instance-policy" {
  name = "London-wifi-backend-bastion-instance-policy"
  role = "London-wifi-backend-bastion-instance-role"

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
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::wifi-london-pp-data/*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "London-wifi-rds-monitoring-role_London-wifi-rds-monitoring-policy" {
  name = "London-wifi-rds-monitoring-policy"
  role = "London-wifi-rds-monitoring-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableCreationAndManagementOfRDSCloudwatchLogGroups",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:PutRetentionPolicy"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:RDS*"
      ]
    },
    {
      "Sid": "EnableCreationAndManagementOfRDSCloudwatchLogStreams",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:RDS*:log-stream:*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "NewsiteRedirect-SESEmailForwardRole-1BAO15HN9AO0C_SESEmailForward" {
  name = "SESEmailForward"
  role = "NewsiteRedirect-SESEmailForwardRole-1BAO15HN9AO0C"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      "Resource": "*",
      "Effect": "Allow"
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

resource "aws_iam_role_policy" "staging-logging-scheduled-task-role_staging-logging-scheduled-task-policy" {
  name = "staging-logging-scheduled-task-policy"
  role = "staging-logging-scheduled-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ecs:RunTask",
      "Resource": "arn:aws:ecs:eu-west-2:${var.aws-account-id}:task-definition/logging-api-scheduled-task-staging:*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "staging-safe-restart-scheduled-task-role_staging-safe-restart-scheduled-task-policy" {
  name = "staging-safe-restart-scheduled-task-policy"
  role = "staging-safe-restart-scheduled-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ecs:RunTask",
      "Resource": "arn:aws:ecs:eu-west-2:${var.aws-account-id}:task-definition/safe-restart-task-staging:*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "staging-safe-restart-task-role_staging-safe-restart-task-policy" {
  name = "staging-safe-restart-task-policy"
  role = "staging-safe-restart-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:ListClusters",
        "ecs:ListTasks",
        "ecs:StopTask",
        "route53:ListHealthChecks",
        "route53:GetHealthCheckStatus"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "staging-user-signup-api-task-role_staging-user-signup-api-task-policy" {
  name = "staging-user-signup-api-task-policy"
  role = "staging-user-signup-api-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::staging-emailbucket/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-admin/signup-whitelist.conf"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::govwifi-staging-metrics-bucket/*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "staging-user-signup-scheduled-task-role_staging-user-signup-scheduled-task-policy" {
  name = "staging-user-signup-scheduled-task-policy"
  role = "staging-user-signup-scheduled-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ecs:RunTask",
      "Resource": "arn:aws:ecs:eu-west-2:${var.aws-account-id}:task-definition/user-signup-api-scheduled-task-staging:*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "wifi-logging-scheduled-task-role_wifi-logging-scheduled-task-policy" {
  name = "wifi-logging-scheduled-task-policy"
  role = "wifi-logging-scheduled-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ecs:RunTask",
      "Resource": "arn:aws:ecs:eu-west-2:${var.aws-account-id}:task-definition/logging-api-scheduled-task-wifi:*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "wifi-safe-restart-scheduled-task-role_wifi-safe-restart-scheduled-task-policy" {
  name = "wifi-safe-restart-scheduled-task-policy"
  role = "wifi-safe-restart-scheduled-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ecs:RunTask",
      "Resource": "arn:aws:ecs:eu-west-2:${var.aws-account-id}:task-definition/safe-restart-task-wifi:*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "wifi-safe-restart-task-role_wifi-safe-restart-task-policy" {
  name = "wifi-safe-restart-task-policy"
  role = "wifi-safe-restart-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:ListClusters",
        "ecs:ListTasks",
        "ecs:StopTask",
        "route53:ListHealthChecks",
        "route53:GetHealthCheckStatus"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "wifi-user-signup-api-task-role_wifi-user-signup-api-task-policy" {
  name = "wifi-user-signup-api-task-policy"
  role = "wifi-user-signup-api-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::wifi-emailbucket/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-production-admin/signup-whitelist.conf"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::govwifi-wifi-metrics-bucket/*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "backup-rds-to-s3-scheduled-task-role_backup-rds-to-s3-scheduled-task-policy" {
  name = "backup-rds-to-s3-scheduled-task-policy"
  role = "backup-rds-to-s3-scheduled-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ecs:RunTask",
      "Resource": "arn:aws:ecs:eu-west-2:${var.aws-account-id}:task-definition/backup-rds-to-s3-task-staging:*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "wifi-user-signup-scheduled-task-role_wifi-user-signup-scheduled-task-policy" {
  name = "wifi-user-signup-scheduled-task-policy"
  role = "wifi-user-signup-scheduled-task-role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ecs:RunTask",
      "Resource": "arn:aws:ecs:eu-west-2:${var.aws-account-id}:task-definition/user-signup-api-scheduled-task-wifi:*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    }
  ]
}
POLICY

}

