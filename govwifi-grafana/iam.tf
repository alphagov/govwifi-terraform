data "aws_iam_policy_document" "secrets_manager_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      data.aws_secretsmanager_secret.grafana_credentials.arn
    ]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_instance_profile" "grafana-instance-profile" {
  name       = "${var.aws-region}-${var.Env-Name}-grafana-instance-profile"
  role       = aws_iam_role.grafana-instance-role.name
}

resource "aws_iam_role" "grafana-instance-role" {
  name  = "${var.aws-region}-${var.Env-Name}-grafana-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "grafana-instance-policy" {
  name       = "${var.aws-region}-${var.Env-Name}-grafana-instance-policy"
  role       = aws_iam_role.grafana-instance-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF

}
