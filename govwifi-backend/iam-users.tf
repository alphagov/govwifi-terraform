resource "aws_iam_user" "it_govwifi_backup_reader" {
  count = var.backup_mysql_rds ? 1 : 0

  name = "it-govwifi-backup-reader"
  path = "/"
}

resource "aws_iam_user_policy" "backup_s3_read_buckets_user_policy" {
  count = var.backup_mysql_rds ? 1 : 0

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
                "arn:aws:s3:::${local.rds_mysql_backup_bucket}"
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
                "arn:aws:kms:eu-west-2:${var.aws_account_id}:key/*",
                "arn:aws:s3:::${local.rds_mysql_backup_bucket}/*"
            ]
        }
    ]
}
POLICY

}
