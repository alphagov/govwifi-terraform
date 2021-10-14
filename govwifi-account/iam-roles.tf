resource "aws_iam_role" "admin_ecsTaskExecutionRole_production_London" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "admin-ecsTaskExecutionRole-production-London"
  path  = "/"

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

resource "aws_iam_role" "admin_ecsTaskExecutionRole_staging_London" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "admin-ecsTaskExecutionRole-staging-London"
  path  = "/"

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

resource "aws_iam_role" "AggregateStagingMetrics_role_gej26flk" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "AggregateStagingMetrics-role-gej26flk"
  path  = "/service-role/"

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
  count = var.is_production_aws_account ? 1 : 0
  name  = "AWSServiceRoleForAmazonGuardDuty"
  path  = "/aws-service-role/guardduty.amazonaws.com/"

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
  count = var.is_production_aws_account ? 1 : 0
  name  = "AWSServiceRoleForApplicationAutoScaling_ECSService"
  path  = "/aws-service-role/ecs.application-autoscaling.amazonaws.com/"

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
  count       = var.is_production_aws_account ? 1 : 0
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
  count = var.is_production_aws_account ? 1 : 0
  name  = "AWSServiceRoleForCloudTrail"
  path  = "/aws-service-role/cloudtrail.amazonaws.com/"

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
  count       = var.is_production_aws_account ? 1 : 0
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
  count       = var.is_production_aws_account ? 1 : 0
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
  count       = var.is_production_aws_account ? 1 : 0
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
  count       = var.is_production_aws_account ? 1 : 0
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
  count       = var.is_production_aws_account ? 1 : 0
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
  count       = var.is_production_aws_account ? 1 : 0
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
  count       = var.is_production_aws_account ? 1 : 0
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
  count = var.is_production_aws_account ? 1 : 0
  name  = "AWSServiceRoleForSecurityHub"
  path  = "/aws-service-role/securityhub.amazonaws.com/"

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
  count       = var.is_production_aws_account ? 1 : 0
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
  count       = var.is_production_aws_account ? 1 : 0
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
  count = var.is_production_aws_account ? 1 : 0
  name  = "CloudTrail_CloudWatchLogs_Role"
  path  = "/"

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

resource "aws_iam_role" "Dublin_ecs_instance_role_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-instance-role-staging"
  path  = "/"

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

resource "aws_iam_role" "Dublin_ecs_instance_role_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-instance-role-wifi"
  path  = "/"

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

resource "aws_iam_role" "Dublin_ecs_service_role_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-service-role-staging"
  path  = "/"

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

resource "aws_iam_role" "Dublin_ecs_service_role_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-service-role-wifi"
  path  = "/"

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

resource "aws_iam_role" "Dublin_frontend_ecs_instance_role_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-instance-role-staging"
  path  = "/"

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

resource "aws_iam_role" "Dublin_frontend_ecs_instance_role_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-instance-role-wifi"
  path  = "/"

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

resource "aws_iam_role" "Dublin_frontend_ecs_task_role_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-task-role-staging"
  path  = "/"

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

resource "aws_iam_role" "Dublin_frontend_ecs_task_role_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-task-role-wifi"
  path  = "/"

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

resource "aws_iam_role" "Dublin_staging_rds_monitoring_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-staging-rds-monitoring-role"
  path  = "/"

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

resource "aws_iam_role" "Dublin_wifi_backend_bastion_instance_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-wifi-backend-bastion-instance-role"
  path  = "/"

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

resource "aws_iam_role" "Dublin_wifi_rds_monitoring_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-wifi-rds-monitoring-role"
  path  = "/"

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

resource "aws_iam_role" "ecsTaskExecutionRole_production_dublin" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "ecsTaskExecutionRole-production-dublin"
  path  = "/"

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

resource "aws_iam_role" "ecsTaskExecutionRole_production_London" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "ecsTaskExecutionRole-production-London"
  path  = "/"

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

resource "aws_iam_role" "ecsTaskExecutionRole_staging_Dublin" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "ecsTaskExecutionRole-staging-Dublin"
  path  = "/"

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

resource "aws_iam_role" "ecsTaskExecutionRole_staging_London" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "ecsTaskExecutionRole-staging-London"
  path  = "/"

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
  count = var.is_production_aws_account ? 1 : 0
  name  = "flowlogsRole"
  path  = "/"

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
  count       = var.is_production_aws_account ? 1 : 0
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
  count       = var.is_production_aws_account ? 1 : 0
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

resource "aws_iam_role" "govwifi_staging_dublin_accesslogs_replication_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "govwifi-staging-dublin-accesslogs-replication-role"
  path  = "/"

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

resource "aws_iam_role" "govwifi_staging_dublin_tfstate_replication_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "govwifi-staging-dublin-tfstate-replication-role"
  path  = "/"

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

resource "aws_iam_role" "govwifi_staging_london_accesslogs_replication_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "govwifi-staging-london-accesslogs-replication-role"
  path  = "/"

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

resource "aws_iam_role" "govwifi_staging_london_tfstate_replication_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "govwifi-staging-london-tfstate-replication-role"
  path  = "/"

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

resource "aws_iam_role" "govwifi_wifi_dublin_accesslogs_replication_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "govwifi-wifi-dublin-accesslogs-replication-role"
  path  = "/"

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

resource "aws_iam_role" "govwifi_wifi_dublin_tfstate_replication_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "govwifi-wifi-dublin-tfstate-replication-role"
  path  = "/"

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

resource "aws_iam_role" "govwifi_wifi_london_accesslogs_replication_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "govwifi-wifi-london-accesslogs-replication-role"
  path  = "/"

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

resource "aws_iam_role" "govwifi_wifi_london_tfstate_replication_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "govwifi-wifi-london-tfstate-replication-role"
  path  = "/"

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

resource "aws_iam_role" "GovWifiMetricsAggregationPrototype_role_ayhlh17x" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "GovWifiMetricsAggregationPrototype-role-ayhlh17x"
  path  = "/service-role/"

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

resource "aws_iam_role" "ITHC_RO_SecAud_Access" {
  count                = var.is_production_aws_account ? 1 : 0
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

resource "aws_iam_role" "London_ecs_admin_instance_role_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-admin-instance-role-staging"
  path  = "/"

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

resource "aws_iam_role" "London_ecs_admin_instance_role_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-admin-instance-role-wifi"
  path  = "/"

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

resource "aws_iam_role" "London_ecs_instance_role_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-instance-role-staging"
  path  = "/"

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

resource "aws_iam_role" "London_ecs_instance_role_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-instance-role-wifi"
  path  = "/"

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

resource "aws_iam_role" "London_ecs_service_role_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-service-role-staging"
  path  = "/"

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

resource "aws_iam_role" "London_ecs_service_role_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-service-role-wifi"
  path  = "/"

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

resource "aws_iam_role" "London_frontend_ecs_instance_role_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-instance-role-staging"
  path  = "/"

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

resource "aws_iam_role" "London_frontend_ecs_instance_role_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-instance-role-wifi"
  path  = "/"

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

resource "aws_iam_role" "London_frontend_ecs_task_role_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-task-role-staging"
  path  = "/"

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

resource "aws_iam_role" "London_frontend_ecs_task_role_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-task-role-wifi"
  path  = "/"

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

resource "aws_iam_role" "London_staging_backend_bastion_instance_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-staging-backend-bastion-instance-role"
  path  = "/"

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

resource "aws_iam_role" "London_staging_rds_monitoring_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-staging-rds-monitoring-role"
  path  = "/"

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

resource "aws_iam_role" "London_wifi_backend_bastion_instance_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-wifi-backend-bastion-instance-role"
  path  = "/"

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

resource "aws_iam_role" "London_wifi_rds_monitoring_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-wifi-rds-monitoring-role"
  path  = "/"

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

resource "aws_iam_role" "NewsiteRedirect_SESEmailForwardRole_1BAO15HN9AO0C" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "NewsiteRedirect-SESEmailForwardRole-1BAO15HN9AO0C"
  path  = "/"

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

resource "aws_iam_role" "rds_monitoring_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "rds-monitoring-role"
  path  = "/"

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

resource "aws_iam_role" "s3crr_role_for_govwifi_staging_dublin_tfstate_to_govwifi_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "s3crr_role_for_govwifi-staging-dublin-tfstate_to_govwifi-staging"
  path  = "/service-role/"

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

resource "aws_iam_role" "s3crr_role_for_govwifi_staging_ireland_accesslogs_to_govwifi_sta" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "s3crr_role_for_govwifi-staging-ireland-accesslogs_to_govwifi-sta"
  path  = "/service-role/"

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

resource "aws_iam_role" "s3crr_role_for_govwifi_staging_london_accesslogs_to_govwifi_stag" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "s3crr_role_for_govwifi-staging-london-accesslogs_to_govwifi-stag"
  path  = "/service-role/"

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

resource "aws_iam_role" "s3crr_role_for_govwifi_staging_london_tfstate_to_govwifi_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "s3crr_role_for_govwifi-staging-london-tfstate_to_govwifi-staging"
  path  = "/service-role/"

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

resource "aws_iam_role" "s3crr_role_for_test_wifi_mfadelete_to_test_wifi_mfadelete_replic" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "s3crr_role_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replic"
  path  = "/service-role/"

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
  count = var.is_production_aws_account ? 1 : 0
  name  = "SNSSuccessFeedback"
  path  = "/"

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

resource "aws_iam_role" "staging_logging_api_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-logging-api-task-role"
  path  = "/"

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

resource "aws_iam_role" "staging_logging_scheduled_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-logging-scheduled-task-role"
  path  = "/"

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

resource "aws_iam_role" "staging_safe_restart_scheduled_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-safe-restart-scheduled-task-role"
  path  = "/"

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

resource "aws_iam_role" "staging_safe_restart_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-safe-restart-task-role"
  path  = "/"

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

resource "aws_iam_role" "staging_user_signup_api_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-user-signup-api-task-role"
  path  = "/"

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

resource "aws_iam_role" "staging_user_signup_scheduled_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-user-signup-scheduled-task-role"
  path  = "/"

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

resource "aws_iam_role" "StagingMetricsAggregator_prototype_role_saci182v" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "StagingMetricsAggregator-prototype-role-saci182v"
  path  = "/service-role/"

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

resource "aws_iam_role" "test_assume_role" {
  count       = var.is_production_aws_account ? 1 : 0
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

resource "aws_iam_role" "test_staging_rds_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "test-staging-rds-role"
  path  = "/"

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

resource "aws_iam_role" "wifi_logging_api_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-logging-api-task-role"
  path  = "/"

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

resource "aws_iam_role" "wifi_logging_scheduled_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-logging-scheduled-task-role"
  path  = "/"

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

resource "aws_iam_role" "wifi_safe_restart_scheduled_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-safe-restart-scheduled-task-role"
  path  = "/"

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

resource "aws_iam_role" "wifi_safe_restart_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-safe-restart-task-role"
  path  = "/"

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

resource "aws_iam_role" "wifi_user_signup_api_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-user-signup-api-task-role"
  path  = "/"

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

resource "aws_iam_role" "wifi_user_signup_scheduled_task_role" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-user-signup-scheduled-task-role"
  path  = "/"

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
  count = var.is_production_aws_account ? 1 : 0
  name  = "oneClick_CloudTrail_CloudWatchLogs_Role_1510330346083"
  role  = "CloudTrail_CloudWatchLogs_Role"

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

resource "aws_iam_role_policy" "Dublin_ecs_instance_role_staging_Dublin_ecs_instance_policy_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-instance-policy-staging"
  role  = "Dublin-ecs-instance-role-staging"

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

resource "aws_iam_role_policy" "Dublin_ecs_instance_role_wifi_Dublin_ecs_instance_policy_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-instance-policy-wifi"
  role  = "Dublin-ecs-instance-role-wifi"

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

resource "aws_iam_role_policy" "Dublin_ecs_service_role_staging_Dublin_ecs_service_policy_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-service-policy-staging"
  role  = "Dublin-ecs-service-role-staging"

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

resource "aws_iam_role_policy" "Dublin_ecs_service_role_wifi_Dublin_ecs_service_policy_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-ecs-service-policy-wifi"
  role  = "Dublin-ecs-service-role-wifi"

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

resource "aws_iam_role_policy" "Dublin_frontend_ecs_instance_role_staging_Dublin_frontend_ecs_instance_policy_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-instance-policy-staging"
  role  = "Dublin-frontend-ecs-instance-role-staging"

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

resource "aws_iam_role_policy" "Dublin_frontend_ecs_instance_role_wifi_Dublin_frontend_ecs_instance_policy_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-instance-policy-wifi"
  role  = "Dublin-frontend-ecs-instance-role-wifi"

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

resource "aws_iam_role_policy" "Dublin_frontend_ecs_task_role_staging_Dublin_frontend_admin_bucket_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-admin-bucket-staging"
  role  = "Dublin-frontend-ecs-task-role-staging"

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

resource "aws_iam_role_policy" "Dublin_frontend_ecs_task_role_staging_Dublin_frontend_cert_bucket_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-cert-bucket-staging"
  role  = "Dublin-frontend-ecs-task-role-staging"

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

resource "aws_iam_role_policy" "Dublin_frontend_ecs_task_role_staging_Dublin_frontend_ecs_service_policy_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-service-policy-staging"
  role  = "Dublin-frontend-ecs-task-role-staging"

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

resource "aws_iam_role_policy" "Dublin_frontend_ecs_task_role_wifi_Dublin_frontend_admin_bucket_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-admin-bucket-wifi"
  role  = "Dublin-frontend-ecs-task-role-wifi"

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

resource "aws_iam_role_policy" "Dublin_frontend_ecs_task_role_wifi_Dublin_frontend_cert_bucket_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-cert-bucket-wifi"
  role  = "Dublin-frontend-ecs-task-role-wifi"

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

resource "aws_iam_role_policy" "Dublin_frontend_ecs_task_role_wifi_Dublin_frontend_ecs_service_policy_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-frontend-ecs-service-policy-wifi"
  role  = "Dublin-frontend-ecs-task-role-wifi"

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

resource "aws_iam_role_policy" "Dublin_staging_rds_monitoring_role_Dublin_staging_rds_monitoring_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-staging-rds-monitoring-policy"
  role  = "Dublin-staging-rds-monitoring-role"

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

resource "aws_iam_role_policy" "Dublin_wifi_backend_bastion_instance_role_Dublin_wifi_backend_bastion_instance_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-wifi-backend-bastion-instance-policy"
  role  = "Dublin-wifi-backend-bastion-instance-role"

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

resource "aws_iam_role_policy" "Dublin_wifi_rds_monitoring_role_Dublin_wifi_rds_monitoring_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "Dublin-wifi-rds-monitoring-policy"
  role  = "Dublin-wifi-rds-monitoring-role"

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
  count = var.is_production_aws_account ? 1 : 0
  name  = "oneClick_flowlogsRole_1480343201952"
  role  = "flowlogsRole"

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

resource "aws_iam_role_policy" "London_ecs_admin_instance_role_staging_London_ecs_admin_instance_policy_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-admin-instance-policy-staging"
  role  = "London-ecs-admin-instance-role-staging"

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

resource "aws_iam_role_policy" "London_ecs_admin_instance_role_wifi_London_ecs_admin_instance_policy_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-admin-instance-policy-wifi"
  role  = "London-ecs-admin-instance-role-wifi"

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

resource "aws_iam_role_policy" "London_ecs_instance_role_staging_London_ecs_instance_policy_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-instance-policy-staging"
  role  = "London-ecs-instance-role-staging"

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

resource "aws_iam_role_policy" "London_ecs_instance_role_wifi_London_ecs_instance_policy_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-instance-policy-wifi"
  role  = "London-ecs-instance-role-wifi"

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

resource "aws_iam_role_policy" "London_ecs_service_role_staging_London_ecs_service_policy_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-service-policy-staging"
  role  = "London-ecs-service-role-staging"

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

resource "aws_iam_role_policy" "London_ecs_service_role_wifi_London_ecs_service_policy_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-ecs-service-policy-wifi"
  role  = "London-ecs-service-role-wifi"

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

resource "aws_iam_role_policy" "London_frontend_ecs_instance_role_staging_London_frontend_ecs_instance_policy_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-instance-policy-staging"
  role  = "London-frontend-ecs-instance-role-staging"

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

resource "aws_iam_role_policy" "London_frontend_ecs_instance_role_wifi_London_frontend_ecs_instance_policy_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-instance-policy-wifi"
  role  = "London-frontend-ecs-instance-role-wifi"

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

resource "aws_iam_role_policy" "London_frontend_ecs_task_role_staging_London_frontend_admin_bucket_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-admin-bucket-staging"
  role  = "London-frontend-ecs-task-role-staging"

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

resource "aws_iam_role_policy" "London_frontend_ecs_task_role_staging_London_frontend_cert_bucket_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-cert-bucket-staging"
  role  = "London-frontend-ecs-task-role-staging"

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

resource "aws_iam_role_policy" "London_frontend_ecs_task_role_staging_London_frontend_ecs_service_policy_staging" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-service-policy-staging"
  role  = "London-frontend-ecs-task-role-staging"

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

resource "aws_iam_role_policy" "London_frontend_ecs_task_role_wifi_London_frontend_admin_bucket_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-admin-bucket-wifi"
  role  = "London-frontend-ecs-task-role-wifi"

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

resource "aws_iam_role_policy" "London_frontend_ecs_task_role_wifi_London_frontend_cert_bucket_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-cert-bucket-wifi"
  role  = "London-frontend-ecs-task-role-wifi"

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

resource "aws_iam_role_policy" "London_frontend_ecs_task_role_wifi_London_frontend_ecs_service_policy_wifi" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-frontend-ecs-service-policy-wifi"
  role  = "London-frontend-ecs-task-role-wifi"

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

resource "aws_iam_role_policy" "London_staging_backend_bastion_instance_role_London_staging_backend_bastion_instance_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-staging-backend-bastion-instance-policy"
  role  = "London-staging-backend-bastion-instance-role"

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

resource "aws_iam_role_policy" "London_staging_rds_monitoring_role_London_staging_rds_monitoring_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-staging-rds-monitoring-policy"
  role  = "London-staging-rds-monitoring-role"

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

resource "aws_iam_role_policy" "London_wifi_backend_bastion_instance_role_London_wifi_backend_bastion_instance_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-wifi-backend-bastion-instance-policy"
  role  = "London-wifi-backend-bastion-instance-role"

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

resource "aws_iam_role_policy" "London_wifi_rds_monitoring_role_London_wifi_rds_monitoring_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "London-wifi-rds-monitoring-policy"
  role  = "London-wifi-rds-monitoring-role"

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

resource "aws_iam_role_policy" "NewsiteRedirect_SESEmailForwardRole_1BAO15HN9AO0C_SESEmailForward" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "SESEmailForward"
  role  = "NewsiteRedirect-SESEmailForwardRole-1BAO15HN9AO0C"

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
  count = var.is_production_aws_account ? 1 : 0
  name  = "oneClick_SNSSuccessFeedback_1479821088561"
  role  = "SNSSuccessFeedback"

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

resource "aws_iam_role_policy" "staging_logging_scheduled_task_role_staging_logging_scheduled_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-logging-scheduled-task-policy"
  role  = "staging-logging-scheduled-task-role"

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

resource "aws_iam_role_policy" "staging_safe_restart_scheduled_task_role_staging_safe_restart_scheduled_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-safe-restart-scheduled-task-policy"
  role  = "staging-safe-restart-scheduled-task-role"

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

resource "aws_iam_role_policy" "staging_safe_restart_task_role_staging_safe_restart_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-safe-restart-task-policy"
  role  = "staging-safe-restart-task-role"

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

resource "aws_iam_role_policy" "staging_user_signup_api_task_role_staging_user_signup_api_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-user-signup-api-task-policy"
  role  = "staging-user-signup-api-task-role"

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

resource "aws_iam_role_policy" "staging_user_signup_scheduled_task_role_staging_user_signup_scheduled_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "staging-user-signup-scheduled-task-policy"
  role  = "staging-user-signup-scheduled-task-role"

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

resource "aws_iam_role_policy" "wifi_logging_scheduled_task_role_wifi_logging_scheduled_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-logging-scheduled-task-policy"
  role  = "wifi-logging-scheduled-task-role"

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

resource "aws_iam_role_policy" "wifi_safe_restart_scheduled_task_role_wifi_safe_restart_scheduled_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-safe-restart-scheduled-task-policy"
  role  = "wifi-safe-restart-scheduled-task-role"

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

resource "aws_iam_role_policy" "wifi_safe_restart_task_role_wifi_safe_restart_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-safe-restart-task-policy"
  role  = "wifi-safe-restart-task-role"

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

resource "aws_iam_role_policy" "wifi_user_signup_api_task_role_wifi_user_signup_api_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-user-signup-api-task-policy"
  role  = "wifi-user-signup-api-task-role"

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

resource "aws_iam_role_policy" "wifi_user_signup_scheduled_task_role_wifi_user_signup_scheduled_task_policy" {
  count = var.is_production_aws_account ? 1 : 0
  name  = "wifi-user-signup-scheduled-task-policy"
  role  = "wifi-user-signup-scheduled-task-role"

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
