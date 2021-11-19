resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole-${var.rack_env}-${var.aws_region_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "secrets_manager_policy" {
  name   = "${var.aws_region_name}-api-cluster-access-secrets-manager-${var.env_name}"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.secrets_manager_policy.json
}

data "aws_iam_policy_document" "secrets_manager_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      data.aws_secretsmanager_secret.users_db.arn,
      data.aws_secretsmanager_secret.session_db.arn,
      data.aws_secretsmanager_secret.admin_db.arn,
      data.aws_secretsmanager_secret.volumetrics_elasticsearch_endpoint.arn,
      data.aws_secretsmanager_secret.notify_api_key.arn,
      data.aws_secretsmanager_secret.notify_bearer_token.arn,
      data.aws_secretsmanager_secret.database_s3_encryption.arn
    ]
  }
}


resource "aws_iam_user" "govwifi_deploy_pipeline" {
  count         = !var.wordlist_bucket_count || var.is_production_aws_account ? 0 : 1
  name          = "govwifi-deploy-pipeline"
  path          = "/"
  force_destroy = false
}

resource "aws_iam_policy" "govwifi_sync_cert_access" {
  count       = !var.wordlist_bucket_count || var.is_production_aws_account ? 0 : 1
  name        = "govwifi-sync-cert-access"
  path        = "/"
  description = "Allows deploy pipeline to access S3 buckets containing SSL certificates"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "govwifiSyncCertAccess",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::govwifi-${var.env_subdomain}-london-frontend-cert/*",
                "arn:aws:s3:::govwifi-${var.env_subdomain}-dublin-frontend-cert/*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "read_wordlist_policy" {
  count       = !var.wordlist_bucket_count || var.is_production_aws_account ? 0 : 1
  name        = "read-wordlist-policy"
  path        = "/"
  description = "Allows deploy pipeline group to read wordlist"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "readWordListPolicy0",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucketVersions",
        "s3:GetBucketVersioning",
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::govwifi-${var.env_subdomain}-wordlist"
    },
    {
      "Sid": "readWordListPolicy1",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObjectVersionAcl"
      ],
      "Resource": "arn:aws:s3:::govwifi-${var.env_subdomain}-wordlist/*"
    }
  ]
}
POLICY

}

resource "aws_iam_user_policy_attachment" "govwifi_sync_cert_access_policy_attachment" {
  count      = !var.wordlist_bucket_count || var.is_production_aws_account ? 0 : 1
  user       = aws_iam_user.govwifi_deploy_pipeline[0].name
  policy_arn = aws_iam_policy.govwifi_sync_cert_access[0].arn
}

resource "aws_iam_user_policy_attachment" "govwifi_read_wordlist_policy_attachment" {
  count      = !var.wordlist_bucket_count || var.is_production_aws_account ? 0 : 1
  user       = aws_iam_user.govwifi_deploy_pipeline[0].name
  policy_arn = aws_iam_policy.read_wordlist_policy[0].arn
}

resource "aws_iam_user_policy_attachment" "govwifi_ecs_policy_attachment" {
  count      = !var.wordlist_bucket_count || var.is_production_aws_account ? 0 : 1
  user       = aws_iam_user.govwifi_deploy_pipeline[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_user_policy_attachment" "govwifi_ecr_policy_attachment" {
  count      = !var.wordlist_bucket_count || var.is_production_aws_account ? 0 : 1
  user       = aws_iam_user.govwifi_deploy_pipeline[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
