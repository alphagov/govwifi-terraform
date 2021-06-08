resource "aws_iam_user_policy" "monitoring-stats-user_monitoring-stats-user-policy" {
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

resource "aws_iam_user_policy" "backup-s3-read-buckets-user-policy" {
  name = "backup-s3-read-buckets"
  user = "it-govwifi-backup-reader"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "sid1",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject*",
        "s3:List*"
      ],
      "Resource": [
        "arn:aws:s3:::govwifi-staging-london-mysql-backup-data",
        "arn:aws:s3:::govwifi-staging-london-mysql-backup-data/*",
        "arn:aws:s3:::govwifi-wifi-london-mysql-backup-data",
        "arn:aws:s3:::govwifi-wifi-london-mysql-backup-data/*"
      ]
    }, {
      "Sid": "sid2",
      "Effect": "Allow",
      "Action": [
         "kms:*"
       ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "kms:RequestAlias": "alias/*_mysql_rds_backup_s3_key"
        }
      }
    }
  ]
}
POLICY

}

