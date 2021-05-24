data "aws_iam_policy_document" "secrets_manager_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      data.aws_secretsmanager_secret.google_client_id.arn,
      data.aws_secretsmanager_secret.google_client_secret.arn,
      data.aws_secretsmanager_secret.grafana_admin.arn,
      data.aws_secretsmanager_secret.grafana_server_root_url.arn
    ]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}