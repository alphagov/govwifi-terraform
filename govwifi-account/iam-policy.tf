resource "aws_iam_policy" "AWSLambdaBasicExecutionRole_e112f67b_c533_4923_98f7_38c38c5e51dc" {
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
      "Resource": "arn:aws:logs:us-east-1:${var.aws_account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:us-east-1:${var.aws_account_id}:log-group:/aws/lambda/GovWifiMetricsAggregationPrototype:*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_policy" "AWSLambdaBasicExecutionRole_9d382291_dcd5_4d68_8a4d_aef9bab6e0b5" {
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
      "Resource": "arn:aws:logs:eu-west-1:${var.aws_account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:eu-west-1:${var.aws_account_id}:log-group:/aws/lambda/AggregateStagingMetrics:*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_policy" "CloudTrailPolicyForCloudWatchLogs_dab06026_75de_4ad1_a922_e4fc41e01568" {
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
        "arn:aws:logs:eu-west-1:${var.aws_account_id}:log-group:CloudTrail/DefaultLogGroup:log-stream:${var.aws_account_id}_CloudTrail_eu-west-1*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents20141101",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:eu-west-1:${var.aws_account_id}:log-group:CloudTrail/DefaultLogGroup:log-stream:${var.aws_account_id}_CloudTrail_eu-west-1*"
      ]
    }
  ]
}
POLICY

}

resource "aws_iam_policy" "AWSLambdaBasicExecutionRole_164db990_7033_4bb4_aaed_380d56e59518" {
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
      "Resource": "arn:aws:logs:eu-west-2:${var.aws_account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:eu-west-2:${var.aws_account_id}:log-group:/aws/lambda/StagingMetricsAggregator-prototype:*"
      ]
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
        "arn:aws:ecs:*:${var.aws_account_id}:task-definition/user-signup-api-task-staging:13"
      ],
      "Condition": {
        "ArnLike": {
          "ecs:cluster": "arn:aws:ecs:*:${var.aws_account_id}:cluster/staging-api-cluster"
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

resource "aws_iam_policy" "s3crr_for_test_wifi_mfadelete_to_test_wifi_mfadelete_replica" {
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

resource "aws_iam_policy" "govwifi_wifi_dublin_tfstate_replication_policy" {
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

resource "aws_iam_policy" "govwifi_wifi_london_tfstate_replication_policy" {
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

resource "aws_iam_policy" "govwifi_wifi_dublin_accesslogs_replication_policy" {
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

resource "aws_iam_policy" "govwifi_wifi_london_accesslogs_replication_policy" {
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
