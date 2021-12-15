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
