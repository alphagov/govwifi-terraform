locals {
  admin_app_data_s3_bucket_arn = "arn:aws:s3:::${var.admin_app_data_s3_bucket_name}"
}

resource "aws_iam_role_policy" "ecs_instance_policy" {
  name = "${var.aws_region_name}-frontend-ecs-instance-policy-${var.env_name}"
  role = aws_iam_role.ecs_instance_role.id

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

resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.aws_region_name}-frontend-ecs-instance-role-${var.env_name}"

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

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.aws_region_name}-frontend-ecs-instance-profile-${var.env_name}"
  role = aws_iam_role.ecs_instance_role.name
}

# Unused until a loadbalancer is set up
resource "aws_iam_role_policy" "ecs_service_policy" {
  name = "${var.aws_region_name}-frontend-ecs-service-policy-${var.env_name}"
  role = aws_iam_role.ecs_task_role.id

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

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.aws_region_name}-frontend-ecs-task-role-${var.env_name}"

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
  name   = "${var.aws_region_name}-frontend-cert-bucket-${var.env_name}"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.cert_bucket_policy.json
}

data "aws_iam_policy_document" "cert_bucket_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.frontend_cert_bucket[0].arn,
      "${aws_s3_bucket.frontend_cert_bucket[0].arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "admin_bucket_policy" {
  name   = "${var.aws_region_name}-frontend-admin-bucket-${var.env_name}"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.admin_bucket_policy.json
}

data "aws_iam_policy_document" "admin_bucket_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      local.admin_app_data_s3_bucket_arn,
      "${local.admin_app_data_s3_bucket_arn}/*",
    ]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole-${var.rack_env}-${var.aws_region_name}-SecretsManager"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "secrets_manager_policy" {
  name   = "${var.aws_region_name}-radius-access-secrets-manager-${var.env_name}"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.secrets_manager_policy.json
}

data "aws_iam_policy_document" "secrets_manager_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      data.aws_secretsmanager_secret.healthcheck.arn,
      data.aws_secretsmanager_secret.shared_key.arn
    ]
  }
}
