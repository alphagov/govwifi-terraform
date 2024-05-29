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
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.frontend_cert_bucket.arn}/*"
      ]
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
      aws_s3_bucket.frontend_cert_bucket.arn,
      "${aws_s3_bucket.frontend_cert_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "allow_ssm" {
  name   = "${var.aws_region_name}-allow-ssm-${var.env_name}"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.allow_ssm.json
}

data "aws_iam_policy_document" "allow_ssm" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = [
      "*"
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

resource "aws_iam_role" "s3_replication_role" {
  count = "${lower(var.aws_region_name)}" == "london" ? 1 : 0
  name  = "s3-replication-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_replication_attachment" {
  count      = "${lower(var.aws_region_name)}" == "london" ? 1 : 0
  role       = aws_iam_role.s3_replication_role[0].name
  policy_arn = aws_iam_policy.s3_replication_policy[0].arn
}

resource "aws_iam_policy" "s3_replication_policy" {
  count       = "${lower(var.aws_region_name)}" == "london" ? 1 : 0
  name        = "s3-replication-policy"
  description = "IAM policy for S3 frontend certs bucket replication"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:ListBucket",
          "s3:GetReplicationConfiguration",
          "s3:GetObjectVersionTagging"
        ],
        Resource = "${aws_s3_bucket_versioning.frontend_cert_bucket.id}"
        Resource = [
          "arn:aws:s3:::frontend-cert-london-*",
          "arn:aws:s3:::frontend-cert-london-*/trusted_certificates/*",
          "arn:aws:s3:::frontend-cert-dublin-*",
          "arn:aws:s3:::frontend-cert-dublin-*/trusted_certificates/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:ListBucket",
          "s3:GetReplicationConfiguration",
          "s3:GetObjectVersionTagging",
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Resource = [
          "arn:aws:s3:::frontend-cert-dublin-*",
          "arn:aws:s3:::frontend-cert-dublin-*/trusted_certificates/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "kms:DescribeKey",
          "kms:GenerateDataKey",
          "kms:Decrypt",
          "kms:Encrypt"
        ],
        Resource = [
          "${data.aws_kms_key.kms_s3_london[0].arn}",
          "${data.aws_kms_key.kms_s3_dublin[0].arn}"
        ]
      }
    ]
  })
}
