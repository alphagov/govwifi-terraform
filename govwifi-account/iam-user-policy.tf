resource "aws_iam_user_policy" "monitoring_stats_user_monitoring_stats_user_policy" {
  name = "monitoring-stats-user-policy"
  user = "monitoring-stats-user"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowReadingMetricsFromCloudWatch",
      "Effect": "Allow",
      "Action": [
        "cloudwatch:DescribeAlarmsForMetric",
        "cloudwatch:DescribeAlarmHistory",
        "cloudwatch:DescribeAlarms",
        "cloudwatch:ListMetrics",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:GetMetricData"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowReadingLogsFromCloudWatch",
      "Effect": "Allow",
      "Action": [
        "logs:DescribeLogGroups",
        "logs:GetLogGroupFields",
        "logs:StartQuery",
        "logs:StopQuery",
        "logs:GetQueryResults",
        "logs:GetLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowReadingTagsInstancesRegionsFromEC2",
      "Effect": "Allow",
      "Action": ["ec2:DescribeTags", "ec2:DescribeInstances", "ec2:DescribeRegions"],
      "Resource": "*"
    },
    {
      "Sid": "AllowReadingResourcesForTags",
      "Effect": "Allow",
      "Action": "tag:GetResources",
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_user_policy" "backup_s3_read_buckets_user_policy" {
  name = "backup-s3-read-buckets"
  user = "it-govwifi-backup-reader"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "sid0",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-mysql-backup-data",
        "arn:aws:s3:::govwifi-wifi-london-mysql-backup-data"
      ]
    },
    {
      "Sid": "sid1",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "kms:Decrypt"
      ],
      "Resource": [
        "arn:aws:kms:eu-west-2:${var.aws-account-id}:key/*",
        "arn:aws:s3:::govwifi-staging-london-mysql-backup-data/*",
        "arn:aws:s3:::govwifi-wifi-london-mysql-backup-data/*"
      ]
    }
  ]
}
POLICY

}

