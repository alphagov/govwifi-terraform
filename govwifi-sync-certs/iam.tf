resource "aws_iam_role" "govwifi_codebuild_sync_certs" {
  count = (var.aws_region == "eu-west-2" ? 1 : 0)
  name  = "govwifi-sync-certs-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "govwifi_codebuild_sync_certs_policy" {
  count = (var.aws_region == "eu-west-2" ? 1 : 0)
  name  = "GovwifiCodeBuildSyncCerts"
  path  = "/"

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "CloudWatchLogsPolicy"
        },
        {
            "Action": [
                "codecommit:GitPull"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "CodeCommitPolicy"
        },
        {
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::frontend-cert-*",
            "Sid": "AddCertsToS3"
        },
        {
            "Action": "secretsmanager:GetSecretValue",
            "Effect": "Allow",
            "Resource": [
              "arn:aws:secretsmanager:eu-west-2:${var.aws_account_id}:secret:deploy/gpg_key-*",
              "arn:aws:secretsmanager:eu-west-1:${var.aws_account_id}:secret:deploy/gpg_key-*"
            ]
        }
    ],
    "Version": "2012-10-17"
}

EOF

}

resource "aws_iam_role_policy_attachment" "govwifi_codebuild_sync_certs_policy" {
  count      = (var.aws_region == "eu-west-2" ? 1 : 0)
  role       = aws_iam_role.govwifi_codebuild_sync_certs[0].name
  policy_arn = aws_iam_policy.govwifi_codebuild_sync_certs_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "govwifi_sync_certs_param_read" {
  count      = (var.aws_region == "eu-west-2" ? 1 : 0)
  role       = aws_iam_role.govwifi_codebuild_sync_certs[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "govwifi_sync_certs_codebuild_perms" {
  count      = (var.aws_region == "eu-west-2" ? 1 : 0)
  role       = aws_iam_role.govwifi_codebuild_sync_certs[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}
