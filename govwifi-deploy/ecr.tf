resource "aws_ecr_repository" "govwifi_ecr_repo" {
  for_each = toset(var.app_names)
  name     = "govwifi/staging/${each.key}"
}

resource "aws_ecr_repository_policy" "govwifi_ecr_repo_policy" {
  for_each   = toset(var.app_names)
  repository = aws_ecr_repository.govwifi_ecr_repo[each.key].name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowPushPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.aws_staging_account_id}:root"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
    }
  ]
}
EOF
}
