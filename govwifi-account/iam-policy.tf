variable "account-id" {}

resource "aws_iam_policy" "AWSLambdaBasicExecutionRole-e112f67b-c533-4923-98f7-38c38c5e51dc" {
  name        = "AWSLambdaBasicExecutionRole-e112f67b-c533-4923-98f7-38c38c5e51dc"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:us-east-1:${var.account-id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:us-east-1:${var.account-id}:log-group:/aws/lambda/GovWifiMetricsAggregationPrototype:*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "AWSLambdaBasicExecutionRole-9d382291-dcd5-4d68-8a4d-aef9bab6e0b5" {
  name        = "AWSLambdaBasicExecutionRole-9d382291-dcd5-4d68-8a4d-aef9bab6e0b5"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:eu-west-1:${var.account-id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:eu-west-1:${var.account-id}:log-group:/aws/lambda/AggregateStagingMetrics:*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "ITHC-Staging-Cyberis-Policy" {
  name        = "ITHC-Staging-Cyberis-Policy"
  path        = "/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": [
            "90.155.48.192/26",
            "81.2.127.144/28",
            "88.97.60.11/24",
            "3.10.4.97/24",
            "213.86.153.212/32",
            "213.86.153.213/32",
            "213.86.153.214/32",
            "213.86.153.235/32",
            "213.86.153.236/32",
            "213.86.153.237/32",
            "85.133.67.244/32"
          ]
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "CloudTrailPolicyForCloudWatchLogs_dab06026-75de-4ad1-a922-e4fc41e01568" {
  name        = "CloudTrailPolicyForCloudWatchLogs_dab06026-75de-4ad1-a922-e4fc41e01568"
  path        = "/service-role/"
  description = "CloudTrail policy to send logs to CloudWatch Logs"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream2014110",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:eu-west-1:${var.account-id}:log-group:CloudTrail/DefaultLogGroup:log-stream:${var.account-id}_CloudTrail_eu-west-1*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents20141101",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:eu-west-1:${var.account-id}:log-group:CloudTrail/DefaultLogGroup:log-stream:${var.account-id}_CloudTrail_eu-west-1*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "AWSLambdaBasicExecutionRole-164db990-7033-4bb4-aaed-380d56e59518" {
  name        = "AWSLambdaBasicExecutionRole-164db990-7033-4bb4-aaed-380d56e59518"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:eu-west-2:${var.account-id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:eu-west-2:${var.account-id}:log-group:/aws/lambda/StagingMetricsAggregator-prototype:*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "ITHC-Access-Key-Policy" {
  name        = "ITHC-Access-Key-Policy"
  path        = "/"
  description = "Grant ITHC pentester permission to create an Access Key. Delete once ITHC is complete. This is a one-time-only access policy."

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CreateOwnAccessKeys",
      "Effect": "Allow",
      "Action": [
        "iam:CreateAccessKey",
        "iam:GetUser",
        "iam:ListAccessKeys"
      ],
      "Resource": "arn:aws:iam::*:user/$aws:username"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "AWS_Events_Invoke_ECS_961488249" {
  name        = "AWS_Events_Invoke_ECS_961488249"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RunTask"
      ],
      "Resource": [
        "arn:aws:ecs:*:${var.account-id}:task-definition/user-signup-api-task-staging:13"
      ],
      "Condition": {
        "ArnLike": {
          "ecs:cluster": "arn:aws:ecs:*:${var.account-id}:cluster/staging-api-cluster"
        }
      }
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

resource "aws_iam_policy" "s3crr_kms_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate" {
  name        = "s3crr_kms_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetReplicationConfiguration",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-tfstate",
        "arn:aws:s3:::govwifi-staging-london-tfstate/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLikeIfExists": {
          "s3:x-amz-server-side-encryption": [
            "aws:kms",
            "AES256"
          ],
          "s3:x-amz-server-side-encryption-aws-kms-key-id": [
            "arn:aws:kms:eu-west-1:${var.account-id}:key/a6535eb7-ca94-4abc-8ecb-94b8650be41a"
          ]
        }
      },
      "Resource": "arn:aws:s3:::govwifi-staging-dublin-tfstate/*"
    },
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.eu-west-2.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "arn:aws:s3:::govwifi-staging-london-tfstate/*"
          ]
        }
      },
      "Resource": [
        "arn:aws:kms:eu-west-2:${var.account-id}:key/1d262f07-6e60-423a-b1e6-61fb6d95eca3"
      ]
    },
    {
      "Action": [
        "kms:Encrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.eu-west-1.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "arn:aws:s3:::govwifi-staging-dublin-tfstate/*"
          ]
        }
      },
      "Resource": [
        "arn:aws:kms:eu-west-1:${var.account-id}:key/a6535eb7-ca94-4abc-8ecb-94b8650be41a"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "GovWifi-Admin" {
  name        = "GovWifi-Admin"
  path        = "/"
  description = "Full access to all GovWifi resources in Live and Staging"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/Product": "GovWifi"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "s3crr_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate" {
  name        = "s3crr_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-dublin-tfstate",
        "arn:aws:s3:::govwifi-staging-dublin-tfstate/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-london-tfstate/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "govwifi-staging-london-accesslogs-replication-policy" {
  name        = "govwifi-staging-london-accesslogs-replication-policy"
  path        = "/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-accesslogs"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-accesslogs/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-dublin-accesslogs/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "govwifi-staging-dublin-accesslogs-replication-policy" {
  name        = "govwifi-staging-dublin-accesslogs-replication-policy"
  path        = "/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-dublin-accesslogs"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-dublin-accesslogs/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-london-accesslogs/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "s3crr_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replica" {
  name        = "s3crr_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replica"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::test-wifi-mfadelete",
        "arn:aws:s3:::test-wifi-mfadelete/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::test-wifi-mfadelete-replica/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "GovWifi-Developers" {
  name        = "GovWifi-Developers"
  path        = "/"
  description = "Allows access to all GovWifi Staging Resources"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/Product": "GovWifi"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/Environment": "Staging"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "govwifi-wifi-dublin-tfstate-replication-policy" {
  name        = "govwifi-wifi-dublin-tfstate-replication-policy"
  path        = "/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-wifi-dublin-tfstate"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-wifi-dublin-tfstate/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-wifi-london-tfstate/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "s3crr_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate" {
  name        = "s3crr_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-tfstate",
        "arn:aws:s3:::govwifi-staging-london-tfstate/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-dublin-tfstate/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "GovWifi-Audit" {
  name        = "GovWifi-Audit"
  path        = "/"
  description = "Can view selected resources in entire tennancy - for ITHC SyOps audit"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "acm:ListCertificates",
        "acm:DescribeCertificate",
        "cloudformation:getStackPolicy",
        "logs:describeLogGroups",
        "logs:describeMetricFilters",
        "logs:DescribeResourcePolicies",
        "autoscaling:Describe*",
        "cloudformation:DescribeStack*",
        "cloudformation:GetTemplate",
        "cloudformation:ListStack*",
        "cloudfront:Get*",
        "cloudfront:List*",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudtrail:ListTags",
        "cloudwatch:Describe*",
        "codecommit:BatchGetRepositories",
        "codecommit:GetBranch",
        "codecommit:GetObjectIdentifier",
        "codecommit:GetRepository",
        "codecommit:List*",
        "codedeploy:Batch*",
        "codedeploy:Get*",
        "codedeploy:List*",
        "config:Deliver*",
        "config:Describe*",
        "config:Get*",
        "datapipeline:DescribeObjects",
        "datapipeline:DescribePipelines",
        "datapipeline:EvaluateExpression",
        "datapipeline:GetPipelineDefinition",
        "datapipeline:ListPipelines",
        "datapipeline:QueryObjects",
        "datapipeline:ValidatePipelineDefinition",
        "directconnect:Describe*",
        "dynamodb:ListTables",
        "ec2:Describe*",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticbeanstalk:Describe*",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:DescribeJobFlows",
        "elasticmapreduce:ListClusters",
        "elasticmapreduce:ListInstances",
        "es:ListDomainNames",
        "es:Describe*",
        "firehose:Describe*",
        "firehose:List*",
        "glacier:DescribeVault",
        "glacier:GetVaultAccessPolicy",
        "glacier:ListVaults",
        "iam:GenerateCredentialReport",
        "iam:Get*",
        "iam:List*",
        "kms:Describe*",
        "kms:Get*",
        "kms:List*",
        "lambda:GetPolicy",
        "lambda:ListFunctions",
        "rds:Describe*",
        "rds:DownloadDBLogFilePortion",
        "rds:ListTagsForResource",
        "redshift:Describe*",
        "route53:GetChange",
        "route53:GetCheckerIpRanges",
        "route53:GetGeoLocation",
        "route53:GetHealthCheck",
        "route53:GetHealthCheckCount",
        "route53:GetHealthCheckLastFailureReason",
        "route53:GetHostedZone",
        "route53:GetHostedZoneCount",
        "route53:GetReusableDelegationSet",
        "route53:ListGeoLocations",
        "route53:ListHealthChecks",
        "route53:ListHostedZones",
        "route53:ListHostedZonesByName",
        "route53:ListResourceRecordSets",
        "route53:ListReusableDelegationSets",
        "route53:ListTagsForResource",
        "route53:ListTagsForResources",
        "route53domains:GetDomainDetail",
        "route53domains:GetOperationDetail",
        "route53domains:ListDomains",
        "route53domains:ListOperations",
        "route53domains:ListTagsForDomain",
        "s3:GetBucket*",
        "s3:GetAccelerateConfiguration",
        "s3:GetAnalyticsConfiguration",
        "s3:GetInventoryConfiguration",
        "s3:GetMetricsConfiguration",
        "s3:GetReplicationConfiguration",
        "s3:GetLifecycleConfiguration",
        "s3:GetObjectAcl",
        "s3:GetObjectVersionAcl",
        "s3:ListAllMyBuckets",
        "sdb:DomainMetadata",
        "sdb:ListDomains",
        "ses:GetIdentityDkimAttributes",
        "ses:GetIdentityVerificationAttributes",
        "ses:ListIdentities",
        "sns:GetTopicAttributes",
        "sns:ListSubscriptionsByTopic",
        "sns:ListTopics",
        "sqs:GetQueueAttributes",
        "sqs:ListQueues",
        "tag:GetResources",
        "tag:GetTagKeys"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/Product": "GovWifi"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "s3crr_kms_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate" {
  name        = "s3crr_kms_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetReplicationConfiguration",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-dublin-tfstate",
        "arn:aws:s3:::govwifi-staging-dublin-tfstate/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLikeIfExists": {
          "s3:x-amz-server-side-encryption": [
            "aws:kms",
            "AES256"
          ],
          "s3:x-amz-server-side-encryption-aws-kms-key-id": [
            "arn:aws:kms:eu-west-2:${var.account-id}:key/1d262f07-6e60-423a-b1e6-61fb6d95eca3"
          ]
        }
      },
      "Resource": "arn:aws:s3:::govwifi-staging-london-tfstate/*"
    },
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.eu-west-1.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "arn:aws:s3:::govwifi-staging-dublin-tfstate/*"
          ]
        }
      },
      "Resource": [
        "arn:aws:kms:eu-west-1:${var.account-id}:key/a6535eb7-ca94-4abc-8ecb-94b8650be41a"
      ]
    },
    {
      "Action": [
        "kms:Encrypt"
      ],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.eu-west-2.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "arn:aws:s3:::govwifi-staging-london-tfstate/*"
          ]
        }
      },
      "Resource": [
        "arn:aws:kms:eu-west-2:${var.account-id}:key/1d262f07-6e60-423a-b1e6-61fb6d95eca3"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "govwifi-wifi-london-tfstate-replication-policy" {
  name        = "govwifi-wifi-london-tfstate-replication-policy"
  path        = "/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-wifi-london-tfstate"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-wifi-london-tfstate/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-wifi-dublin-tfstate/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "govwifi-wifi-dublin-accesslogs-replication-policy" {
  name        = "govwifi-wifi-dublin-accesslogs-replication-policy"
  path        = "/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-wifi-dublin-accesslogs"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-wifi-dublin-accesslogs/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-wifi-london-accesslogs/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "s3crr_for_govwifi-staging-london-accesslogs_to_govwifi-staging-ireland-accesslogs" {
  name        = "s3crr_for_govwifi-staging-london-accesslogs_to_govwifi-staging-ireland-accesslogs"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-accesslogs",
        "arn:aws:s3:::govwifi-staging-london-accesslogs/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-ireland-accesslogs/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "LambdaUpdateFunctionCode" {
  name        = "LambdaUpdateFunctionCode"
  path        = "/"
  description = "For use with deployment from Jenkins"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "lambda:UpdateFunctionCode",
      "Resource": "arn:aws:lambda:*:*:function:*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "govwifi-staging-london-tfstate-replication-policy" {
  name        = "govwifi-staging-london-tfstate-replication-policy"
  path        = "/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-tfstate"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-tfstate/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-dublin-tfstate/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "govwifi-wifi-london-accesslogs-replication-policy" {
  name        = "govwifi-wifi-london-accesslogs-replication-policy"
  path        = "/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-wifi-london-accesslogs"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-wifi-london-accesslogs/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-wifi-dublin-accesslogs/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "govwifi-staging-dublin-tfstate-replication-policy" {
  name        = "govwifi-staging-dublin-tfstate-replication-policy"
  path        = "/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-dublin-tfstate"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-dublin-tfstate/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-london-tfstate/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "GovWifi-Admin-S3-Policy" {
  name        = "GovWifi-Admin-S3-Policy"
  path        = "/"
  description = "Allows access to specific S3 buckets with explicit deny on following actions DeleteBucket, DeleteObject, DeleteBucketPolicy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "s3:PutAnalyticsConfiguration",
        "s3:GetObjectVersionTagging",
        "s3:CreateBucket",
        "s3:ReplicateObject",
        "s3:GetObjectAcl",
        "s3:DeleteBucketWebsite",
        "s3:PutLifecycleConfiguration",
        "s3:GetObjectVersionAcl",
        "s3:PutBucketAcl",
        "s3:PutObjectTagging",
        "s3:GetIpConfiguration",
        "s3:DeleteObjectTagging",
        "s3:GetBucketWebsite",
        "s3:PutReplicationConfiguration",
        "s3:DeleteObjectVersionTagging",
        "s3:GetBucketNotification",
        "s3:PutBucketCORS",
        "s3:GetReplicationConfiguration",
        "s3:ListMultipartUploadParts",
        "s3:PutObject",
        "s3:GetObject",
        "s3:PutBucketNotification",
        "s3:PutBucketLogging",
        "s3:PutObjectVersionAcl",
        "s3:GetAnalyticsConfiguration",
        "s3:GetObjectVersionForReplication",
        "s3:GetLifecycleConfiguration",
        "s3:ListBucketByTags",
        "s3:GetInventoryConfiguration",
        "s3:GetBucketTagging",
        "s3:PutAccelerateConfiguration",
        "s3:DeleteObjectVersion",
        "s3:GetBucketLogging",
        "s3:ListBucketVersions",
        "s3:ReplicateTags",
        "s3:RestoreObject",
        "s3:ListBucket",
        "s3:GetAccelerateConfiguration",
        "s3:GetBucketPolicy",
        "s3:GetObjectVersionTorrent",
        "s3:AbortMultipartUpload",
        "s3:PutBucketTagging",
        "s3:GetBucketRequestPayment",
        "s3:GetObjectTagging",
        "s3:GetMetricsConfiguration",
        "s3:PutBucketVersioning",
        "s3:PutObjectAcl",
        "s3:ListBucketMultipartUploads",
        "s3:PutMetricsConfiguration",
        "s3:PutObjectVersionTagging",
        "s3:GetBucketVersioning",
        "s3:GetBucketAcl",
        "s3:PutInventoryConfiguration",
        "s3:PutIpConfiguration",
        "s3:GetObjectTorrent",
        "s3:ObjectOwnerOverrideToBucketOwner",
        "s3:PutBucketWebsite",
        "s3:PutBucketRequestPayment",
        "s3:GetBucketCORS",
        "s3:PutBucketPolicy",
        "s3:GetBucketLocation",
        "s3:ReplicateDelete",
        "s3:GetObjectVersion"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-tfstate/*",
        "arn:aws:s3:::govwifi-staging-dublin-tfstate/*",
        "arn:aws:s3:::govwifi-staging-dublin-tfstate",
        "arn:aws:s3:::govwifi-staging-london-tfstate"
      ]
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets",
        "s3:HeadBucket",
        "s3:ListObjects"
      ],
      "Resource": "*"
    },
    {
      "Sid": "VisualEditor2",
      "Effect": "Deny",
      "Action": [
        "s3:DeleteObject",
        "s3:DeleteBucketPolicy",
        "s3:DeleteBucket"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-tfstate/*",
        "arn:aws:s3:::govwifi-staging-dublin-tfstate/*",
        "arn:aws:s3:::govwifi-staging-dublin-tfstate",
        "arn:aws:s3:::govwifi-staging-london-tfstate"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "s3crr_for_govwifi-staging-ireland-accesslogs_to_govwifi-staging-london-accesslogs" {
  name        = "s3crr_for_govwifi-staging-ireland-accesslogs_to_govwifi-staging-london-accesslogs"
  path        = "/service-role/"
  description = ""

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::govwifi-staging-ireland-accesslogs",
        "arn:aws:s3:::govwifi-staging-ireland-accesslogs/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-london-accesslogs/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "GovWifi-Support" {
  name        = "GovWifi-Support"
  path        = "/"
  description = "Can view selected resources in Live environment and create AWS Support requests"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "support:*",
        "acm:DescribeCertificate",
        "acm:GetCertificate",
        "acm:List*",
        "apigateway:GET",
        "appstream:Get*",
        "autoscaling:Describe*",
        "aws-marketplace:ViewSubscriptions",
        "cloudformation:Describe*",
        "cloudformation:Get*",
        "cloudformation:List*",
        "cloudformation:EstimateTemplateCost",
        "cloudfront:Get*",
        "cloudfront:List*",
        "cloudsearch:Describe*",
        "cloudsearch:List*",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudtrail:LookupEvents",
        "cloudtrail:ListTags",
        "cloudtrail:ListPublicKeys",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "codecommit:BatchGetRepositories",
        "codecommit:Get*",
        "codecommit:List*",
        "codedeploy:Batch*",
        "codedeploy:Get*",
        "codedeploy:List*",
        "codepipeline:AcknowledgeJob",
        "codepipeline:AcknowledgeThirdPartyJob",
        "codepipeline:ListActionTypes",
        "codepipeline:ListPipelines",
        "codepipeline:PollForJobs",
        "codepipeline:PollForThirdPartyJobs",
        "codepipeline:GetPipelineState",
        "codepipeline:GetPipeline",
        "cognito-identity:List*",
        "cognito-identity:LookupDeveloperIdentity",
        "cognito-identity:Describe*",
        "cognito-idp:Describe*",
        "cognito-sync:Describe*",
        "cognito-sync:GetBulkPublishDetails",
        "cognito-sync:GetCognitoEvents",
        "cognito-sync:GetIdentityPoolConfiguration",
        "cognito-sync:List*",
        "config:DescribeConfigurationRecorders",
        "config:DescribeConfigurationRecorderStatus",
        "config:DescribeConfigRuleEvaluationStatus",
        "config:DescribeConfigRules",
        "config:DescribeDeliveryChannels",
        "config:DescribeDeliveryChannelStatus",
        "config:GetResourceConfigHistory",
        "config:ListDiscoveredResources",
        "datapipeline:DescribeObjects",
        "datapipeline:DescribePipelines",
        "datapipeline:GetPipelineDefinition",
        "datapipeline:ListPipelines",
        "datapipeline:QueryObjects",
        "datapipeline:ReportTaskProgress",
        "datapipeline:ReportTaskRunnerHeartbeat",
        "devicefarm:List*",
        "devicefarm:Get*",
        "directconnect:Describe*",
        "discovery:Describe*",
        "discovery:ListConfigurations",
        "dms:Describe*",
        "dms:List*",
        "ds:DescribeDirectories",
        "ds:DescribeSnapshots",
        "ds:GetDirectoryLimits",
        "ds:GetSnapshotLimits",
        "ds:ListAuthorizedApplications",
        "dynamodb:DescribeLimits",
        "dynamodb:DescribeTable",
        "dynamodb:ListTables",
        "ec2:Describe*",
        "ec2:DescribeHosts",
        "ec2:describeIdentityIdFormat",
        "ec2:DescribeIdFormat",
        "ec2:DescribeInstanceAttribute",
        "ec2:DescribeNatGateways",
        "ec2:DescribeReservedInstancesModifications",
        "ec2:DescribeTags",
        "ec2:GetFlowLogsCount",
        "ecr:GetRepositoryPolicy",
        "ecr:BatchCheckLayerAvailability",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticbeanstalk:Check*",
        "elasticbeanstalk:Describe*",
        "elasticbeanstalk:List*",
        "elasticbeanstalk:RequestEnvironmentInfo",
        "elasticbeanstalk:RetrieveEnvironmentInfo",
        "elasticbeanstalk:ValidateConfigurationSettings",
        "elasticfilesystem:Describe*",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:Describe*",
        "elasticmapreduce:List*",
        "elastictranscoder:List*",
        "elastictranscoder:ReadJob",
        "elasticfilesystem:DescribeFileSystems",
        "es:Describe*",
        "es:List*",
        "es:ESHttpGet",
        "es:ESHttpHead",
        "events:DescribeRule",
        "events:List*",
        "events:TestEventPattern",
        "firehose:Describe*",
        "firehose:List*",
        "gamelift:List*",
        "gamelift:Describe*",
        "glacier:ListVaults",
        "glacier:DescribeVault",
        "glacier:DescribeJob",
        "glacier:Get*",
        "glacier:List*",
        "iam:GenerateCredentialReport",
        "iam:GenerateServiceLastAccessedDetails",
        "iam:Get*",
        "iam:List*",
        "importexport:GetStatus",
        "importexport:ListJobs",
        "importexport:GetJobDetail",
        "inspector:Describe*",
        "inspector:List*",
        "inspector:GetAssessmentTelemetry",
        "inspector:LocalizeText",
        "iot:Describe*",
        "iot:Get*",
        "iot:List*",
        "kinesisanalytics:DescribeApplication",
        "kinesisanalytics:DiscoverInputSchema",
        "kinesisanalytics:GetApplicationState",
        "kinesisanalytics:ListApplications",
        "kinesis:Describe*",
        "kinesis:Get*",
        "kinesis:List*",
        "kms:Describe*",
        "kms:Get*",
        "kms:List*",
        "lambda:List*",
        "lambda:Get*",
        "logs:Describe*",
        "logs:TestMetricFilter",
        "machinelearning:Describe*",
        "machinelearning:Get*",
        "mobilehub:GetProject",
        "mobilehub:List*",
        "mobilehub:ValidateProject",
        "mobilehub:VerifyServiceRole",
        "opsworks:Describe*",
        "rds:Describe*",
        "rds:ListTagsForResource",
        "redshift:Describe*",
        "route53:Get*",
        "route53:List*",
        "route53domains:CheckDomainAvailability",
        "route53domains:GetDomainDetail",
        "route53domains:GetOperationDetail",
        "route53domains:List*",
        "s3:List*",
        "sdb:GetAttributes",
        "sdb:List*",
        "sdb:Select*",
        "servicecatalog:SearchProducts",
        "servicecatalog:DescribeProduct",
        "servicecatalog:DescribeProductView",
        "servicecatalog:ListLaunchPaths",
        "servicecatalog:DescribeProvisioningParameters",
        "servicecatalog:ListRecordHistory",
        "servicecatalog:DescribeRecord",
        "servicecatalog:ScanProvisionedProducts",
        "ses:Get*",
        "ses:List*",
        "sns:Get*",
        "sns:List*",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "sqs:ListQueues",
        "sqs:ReceiveMessage",
        "ssm:List*",
        "ssm:Describe*",
        "storagegateway:Describe*",
        "storagegateway:List*",
        "swf:Count*",
        "swf:Describe*",
        "swf:Get*",
        "swf:List*",
        "waf:Get*",
        "waf:List*",
        "workspaces:Describe*",
        "workdocs:Describe*",
        "workmail:Describe*",
        "workmail:Get*",
        "workspaces:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/Product": "GovWifi"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "govwifi-staging-tfstate-nodelete" {
  name        = "govwifi-staging-tfstate-nodelete"
  path        = "/"
  description = "Prevents accidental deletion of objects in all tfstate buckets"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Deny",
      "Action": [
        "s3:DeleteObject",
        "s3:DeleteBucket"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-dublin-tfstate",
        "arn:aws:s3:::govwifi-staging-london-tfstate"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "AWSLambdaBasicExecutionRole-164db990-7033-4bb4-aaed-380d56e59518-policy-attachment" {
  name       = "AWSLambdaBasicExecutionRole-164db990-7033-4bb4-aaed-380d56e59518-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/AWSLambdaBasicExecutionRole-164db990-7033-4bb4-aaed-380d56e59518"
  groups     = []
  users      = []
  roles      = ["StagingMetricsAggregator-prototype-role-saci182v"]
}

resource "aws_iam_policy_attachment" "AWSLambdaBasicExecutionRole-9d382291-dcd5-4d68-8a4d-aef9bab6e0b5-policy-attachment" {
  name       = "AWSLambdaBasicExecutionRole-9d382291-dcd5-4d68-8a4d-aef9bab6e0b5-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/AWSLambdaBasicExecutionRole-9d382291-dcd5-4d68-8a4d-aef9bab6e0b5"
  groups     = []
  users      = []
  roles      = ["AggregateStagingMetrics-role-gej26flk"]
}

resource "aws_iam_policy_attachment" "AWSLambdaBasicExecutionRole-e112f67b-c533-4923-98f7-38c38c5e51dc-policy-attachment" {
  name       = "AWSLambdaBasicExecutionRole-e112f67b-c533-4923-98f7-38c38c5e51dc-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/AWSLambdaBasicExecutionRole-e112f67b-c533-4923-98f7-38c38c5e51dc"
  groups     = []
  users      = []
  roles      = ["GovWifiMetricsAggregationPrototype-role-ayhlh17x"]
}

resource "aws_iam_policy_attachment" "CloudTrailPolicyForCloudWatchLogs_dab06026-75de-4ad1-a922-e4fc41e01568-policy-attachment" {
  name       = "CloudTrailPolicyForCloudWatchLogs_dab06026-75de-4ad1-a922-e4fc41e01568-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/CloudTrailPolicyForCloudWatchLogs_dab06026-75de-4ad1-a922-e4fc41e01568"
  groups     = []
  users      = []
  roles      = ["CloudTrail_CloudWatchLogs_Role"]
}

resource "aws_iam_policy_attachment" "GovWifi-Admin-policy-attachment" {
  name       = "GovWifi-Admin-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/GovWifi-Admin"
  groups     = ["GovWifi-Admin"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "GovWifi-Admin-S3-Policy-policy-attachment" {
  name       = "GovWifi-Admin-S3-Policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/GovWifi-Admin-S3-Policy"
  groups     = ["GovWifi-Admin"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "GovWifi-Audit-policy-attachment" {
  name       = "GovWifi-Audit-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/GovWifi-Audit"
  groups     = ["GovWifi-Audit"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "GovWifi-Developers-policy-attachment" {
  name       = "GovWifi-Developers-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/GovWifi-Developers"
  groups     = ["GovWifi-Developers"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "govwifi-staging-dublin-accesslogs-replication-policy-policy-attachment" {
  name       = "govwifi-staging-dublin-accesslogs-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/govwifi-staging-dublin-accesslogs-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-dublin-accesslogs-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-staging-dublin-tfstate-replication-policy-policy-attachment" {
  name       = "govwifi-staging-dublin-tfstate-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/govwifi-staging-dublin-tfstate-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-dublin-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-staging-london-accesslogs-replication-policy-policy-attachment" {
  name       = "govwifi-staging-london-accesslogs-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/govwifi-staging-london-accesslogs-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-london-accesslogs-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-staging-london-tfstate-replication-policy-policy-attachment" {
  name       = "govwifi-staging-london-tfstate-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/govwifi-staging-london-tfstate-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-london-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "GovWifi-Support-policy-attachment" {
  name       = "GovWifi-Support-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/GovWifi-Support"
  groups     = ["GovWifi-Support"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "govwifi-wifi-dublin-accesslogs-replication-policy-policy-attachment" {
  name       = "govwifi-wifi-dublin-accesslogs-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/govwifi-wifi-dublin-accesslogs-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-wifi-dublin-accesslogs-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-wifi-dublin-tfstate-replication-policy-policy-attachment" {
  name       = "govwifi-wifi-dublin-tfstate-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/govwifi-wifi-dublin-tfstate-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-wifi-dublin-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-wifi-london-accesslogs-replication-policy-policy-attachment" {
  name       = "govwifi-wifi-london-accesslogs-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/govwifi-wifi-london-accesslogs-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-wifi-london-accesslogs-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-wifi-london-tfstate-replication-policy-policy-attachment" {
  name       = "govwifi-wifi-london-tfstate-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/govwifi-wifi-london-tfstate-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-wifi-london-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "ITHC-Access-Key-Policy-policy-attachment" {
  name       = "ITHC-Access-Key-Policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/ITHC-Access-Key-Policy"
  groups     = ["ITHC-RO-SecAud-Group"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "ITHC-Staging-Cyberis-Policy-policy-attachment" {
  name       = "ITHC-Staging-Cyberis-Policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/ITHC-Staging-Cyberis-Policy"
  groups     = ["ITHC-RO-SecAud-Group"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "LambdaUpdateFunctionCode-policy-attachment" {
  name       = "LambdaUpdateFunctionCode-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/LambdaUpdateFunctionCode"
  groups     = []
  users      = ["govwifi-jenkins-deploy"]
  roles      = []
}

resource "aws_iam_policy_attachment" "s3crr_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate-policy-attachment" {
  name       = "s3crr_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/s3crr_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_govwifi-staging-dublin-tfstate_to_govwifi-staging"]
}

resource "aws_iam_policy_attachment" "s3crr_for_govwifi-staging-ireland-accesslogs_to_govwifi-staging-london-accesslogs-policy-attachment" {
  name       = "s3crr_for_govwifi-staging-ireland-accesslogs_to_govwifi-staging-london-accesslogs-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/s3crr_for_govwifi-staging-ireland-accesslogs_to_govwifi-staging-london-accesslogs"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_govwifi-staging-ireland-accesslogs_to_govwifi-sta"]
}

resource "aws_iam_policy_attachment" "s3crr_for_govwifi-staging-london-accesslogs_to_govwifi-staging-ireland-accesslogs-policy-attachment" {
  name       = "s3crr_for_govwifi-staging-london-accesslogs_to_govwifi-staging-ireland-accesslogs-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/s3crr_for_govwifi-staging-london-accesslogs_to_govwifi-staging-ireland-accesslogs"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_govwifi-staging-london-accesslogs_to_govwifi-stag"]
}

resource "aws_iam_policy_attachment" "s3crr_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate-policy-attachment" {
  name       = "s3crr_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/s3crr_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_govwifi-staging-london-tfstate_to_govwifi-staging"]
}

resource "aws_iam_policy_attachment" "s3crr_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replica-policy-attachment" {
  name       = "s3crr_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replica-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/s3crr_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replica"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replic"]
}

resource "aws_iam_policy_attachment" "s3crr_kms_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate-policy-attachment" {
  name       = "s3crr_kms_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/s3crr_kms_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-dublin-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "s3crr_kms_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate-policy-attachment" {
  name       = "s3crr_kms_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate-policy-attachment"
  policy_arn = "arn:aws:iam::${var.account-id}:policy/service-role/s3crr_kms_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-london-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "AutoScalingServiceRolePolicy-policy-attachment" {
  name       = "AutoScalingServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AutoScalingServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForAutoScaling"]
}

resource "aws_iam_policy_attachment" "AmazonGuardDutyServiceRolePolicy-policy-attachment" {
  name       = "AmazonGuardDutyServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonGuardDutyServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForAmazonGuardDuty"]
}

resource "aws_iam_policy_attachment" "CloudWatchFullAccess-policy-attachment" {
  name       = "CloudWatchFullAccess-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  groups     = []
  users      = []
  roles      = ["StagingMetricsAggregator-prototype-role-saci182v"]
}

resource "aws_iam_policy_attachment" "ReadOnlyAccess-policy-attachment" {
  name       = "ReadOnlyAccess-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  groups     = ["ITHC-RO-SecAud-Group", "Read-Only-Access"]
  users      = []
  roles      = ["ITHC-RO-SecAud-Access", "sebastian.szypowicz-readonly", "colin.burn-murdoch-readonly"]
}

resource "aws_iam_policy_attachment" "AWSElasticLoadBalancingServiceRolePolicy-policy-attachment" {
  name       = "AWSElasticLoadBalancingServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSElasticLoadBalancingServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForElasticLoadBalancing"]
}

resource "aws_iam_policy_attachment" "ElastiCacheServiceRolePolicy-policy-attachment" {
  name       = "ElastiCacheServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/ElastiCacheServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForElastiCache"]
}

resource "aws_iam_policy_attachment" "AmazonRDSServiceRolePolicy-policy-attachment" {
  name       = "AmazonRDSServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonRDSServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForRDS"]
}

resource "aws_iam_policy_attachment" "AWSOrganizationsServiceTrustPolicy-policy-attachment" {
  name       = "AWSOrganizationsServiceTrustPolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSOrganizationsServiceTrustPolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForOrganizations"]
}

resource "aws_iam_policy_attachment" "AmazonEC2ContainerServiceEventsRole-policy-attachment" {
  name       = "AmazonEC2ContainerServiceEventsRole-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
  groups     = []
  users      = ["govwifi-jenkins-deploy"]
  roles      = []
}

resource "aws_iam_policy_attachment" "AmazonECSServiceRolePolicy-policy-attachment" {
  name       = "AmazonECSServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForECS"]
}

resource "aws_iam_policy_attachment" "AdministratorAccess-policy-attachment" {
  name       = "AdministratorAccess-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  groups     = ["GDS-IT-Developers", "AWS-Admin", "GDS-IT-Networks"]
  users      = []
  roles      = ["camille.descartes-admin", "ian.nicholls-admin", "chris.banks-admin", "charles.chani-admin", "stephen.ford-admin", "sarah.young-admin", "frederic.francois-admin", "jos.koetsier-admin", "tom.whitwell-admin", "roch.trinque-admin", "GDSAdminAccessGovWifi"]
}

resource "aws_iam_policy_attachment" "SecurityAudit-policy-attachment" {
  name       = "SecurityAudit-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  groups     = ["ITHC-RO-SecAud-Group"]
  users      = []
  roles      = ["ITHC-RO-SecAud-Access"]
}

resource "aws_iam_policy_attachment" "AWSSupportServiceRolePolicy-policy-attachment" {
  name       = "AWSSupportServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSSupportServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForSupport"]
}

resource "aws_iam_policy_attachment" "AmazonEC2ContainerRegistryPowerUser-policy-attachment" {
  name       = "AmazonEC2ContainerRegistryPowerUser-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  groups     = []
  users      = ["govwifi-jenkins-deploy"]
  roles      = []
}

resource "aws_iam_policy_attachment" "AWSApplicationAutoscalingECSServicePolicy-policy-attachment" {
  name       = "AWSApplicationAutoscalingECSServicePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSApplicationAutoscalingECSServicePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForApplicationAutoScaling_ECSService"]
}

resource "aws_iam_policy_attachment" "AmazonECSTaskExecutionRolePolicy-policy-attachment" {
  name       = "AmazonECSTaskExecutionRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  groups     = []
  users      = []
  roles      = ["ecsTaskExecutionRole-production-London", "admin-ecsTaskExecutionRole-production-London", "ecsTaskExecutionRole-production-dublin", "ecsTaskExecutionRole-staging-London", "admin-ecsTaskExecutionRole-staging-London", "ecsTaskExecutionRole-staging-Dublin"]
}

resource "aws_iam_policy_attachment" "AWSTrustedAdvisorServiceRolePolicy-policy-attachment" {
  name       = "AWSTrustedAdvisorServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSTrustedAdvisorServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForTrustedAdvisor"]
}

resource "aws_iam_policy_attachment" "AWSSecurityHubServiceRolePolicy-policy-attachment" {
  name       = "AWSSecurityHubServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSSecurityHubServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForSecurityHub"]
}

resource "aws_iam_policy_attachment" "AmazonRDSEnhancedMonitoringRole-policy-attachment" {
  name       = "AmazonRDSEnhancedMonitoringRole-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  groups     = []
  users      = []
  roles      = ["rds-monitoring-role", "test-staging-rds-role"]
}

resource "aws_iam_policy_attachment" "CloudTrailServiceRolePolicy-policy-attachment" {
  name       = "CloudTrailServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/CloudTrailServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForCloudTrail"]
}

resource "aws_iam_policy_attachment" "AWSGlobalAcceleratorSLRPolicy-policy-attachment" {
  name       = "AWSGlobalAcceleratorSLRPolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSGlobalAcceleratorSLRPolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForGlobalAccelerator"]
}

resource "aws_iam_policy_attachment" "CloudWatch-CrossAccountAccess-policy-attachment" {
  name       = "CloudWatch-CrossAccountAccess-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/CloudWatch-CrossAccountAccess"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForCloudWatchCrossAccount"]
}
