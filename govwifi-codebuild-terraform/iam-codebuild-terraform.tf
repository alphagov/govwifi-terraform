resource "aws_iam_role" "govwifi_terraform_codebuild_role" {
  name = "govwifi_terraform_codebuild_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "terraform_codebuild_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
  role       = aws_iam_role.govwifi_terraform_codebuild_role.name
}

# resource "aws_iam_role_policy_attachment" "terraform_codebuild_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   role       = aws_iam_role.govwifi_terraform_codebuild_role.name
# }