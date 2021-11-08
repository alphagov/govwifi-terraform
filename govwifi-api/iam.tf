resource "aws_iam_role" "ecsTaskExecutionRole" {
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

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "secrets_manager_policy" {
  name   = "${var.aws_region_name}-api-cluster-access-secrets-manager-${var.env_name}"
  role   = aws_iam_role.ecsTaskExecutionRole.id
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
