locals {
  admin-bucket-arn = "arn:aws:s3:::${var.admin-bucket-name}"
}

resource "aws_iam_role_policy" "ecs-instance-policy" {
  name = "${var.aws-region-name}-frontend-ecs-instance-policy-${var.Env-Name}"
  role = aws_iam_role.ecs-instance-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": [ "*" ]
    },
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
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_role" "ecs-instance-role" {
  name = "${var.aws-region-name}-frontend-ecs-instance-role-${var.Env-Name}"

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

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "${var.aws-region-name}-frontend-ecs-instance-profile-${var.Env-Name}"
  role = aws_iam_role.ecs-instance-role.name
}

# Unused until a loadbalancer is set up
resource "aws_iam_role_policy" "ecs-service-policy" {
  name = "${var.aws-region-name}-frontend-ecs-service-policy-${var.Env-Name}"
  role = aws_iam_role.ecs-task-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
EOF

}

# Unused until a loadbalancer is set up
resource "aws_iam_role" "ecs-task-role" {
  name = "${var.aws-region-name}-frontend-ecs-task-role-${var.Env-Name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "cert_bucket_policy" {
  name   = "${var.aws-region-name}-frontend-cert-bucket-${var.Env-Name}"
  role   = aws_iam_role.ecs-task-role.id
  policy = data.aws_iam_policy_document.cert_bucket_policy.json
}

data "aws_iam_policy_document" "cert_bucket_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.frontend-cert-bucket[0].arn,
      "${aws_s3_bucket.frontend-cert-bucket[0].arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "admin_bucket_policy" {
  name   = "${var.aws-region-name}-frontend-admin-bucket-${var.Env-Name}"
  role   = aws_iam_role.ecs-task-role.id
  policy = data.aws_iam_policy_document.admin_bucket_policy.json
}

data "aws_iam_policy_document" "admin_bucket_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      local.admin-bucket-arn,
      "${local.admin-bucket-arn}/*",
    ]
  }
}

