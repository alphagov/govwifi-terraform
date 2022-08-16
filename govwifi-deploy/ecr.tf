resource "aws_ecr_repository" "govwifi_ecr_repo" {
  for_each = toset(var.deployed_app_names)
  name     = "govwifi/staging/${each.key}"
}

resource "aws_ecr_repository_policy" "govwifi_ecr_repo_policy" {
  for_each   = toset(var.deployed_app_names)
  repository = aws_ecr_repository.govwifi_ecr_repo[each.key].name
  policy     = data.aws_iam_policy_document.govwifi_ecr_repo_policy.json
}

resource "aws_ecr_repository" "govwifi_frontend" {
  for_each = toset(var.frontend_docker_images)
  name     = "govwifi/staging/${each.key}"
}

resource "aws_ecr_repository_policy" "govwifi_frontend_policy" {
  for_each   = toset(var.frontend_docker_images)
  repository = aws_ecr_repository.govwifi_frontend[each.key].name
  policy     = data.aws_iam_policy_document.govwifi_ecr_repo_policy.json
}

resource "aws_ecr_repository" "safe_restarter_ecr" {
  name = "govwifi/staging/safe-restarter"
}

resource "aws_ecr_repository_policy" "govwifi_ecr_saferestater_policy" {
  repository = aws_ecr_repository.safe_restarter_ecr.name
  policy     = data.aws_iam_policy_document.govwifi_ecr_repo_policy.json
}


data "aws_iam_policy_document" "govwifi_ecr_repo_policy" {
  statement {
    sid = "AllowPushPull"

    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_staging_account_id}:root"]
    }

  }

}
