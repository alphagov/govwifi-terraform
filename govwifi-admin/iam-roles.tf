resource "aws_iam_policy" "ecs-admin-instance-policy" {
  name = "${var.aws-region-name}-ecs-admin-instance-policy-${var.Env-Name}"

  #role       = "${aws_iam_role.ecs-admin-instance-role.id}"
  #depends_on = ["aws_s3_bucket.admin-bucket"]

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
    },{
      "Effect": "Allow",
      "Action": [
        "route53:ListHealthChecks",
        "route53:GetHealthCheckStatus"
      ],
      "Resource": "*"
    },{
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": ["${aws_s3_bucket.admin-bucket.arn}/*"]
    },{
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:DeleteObject"
      ],
      "Resource": ["${aws_s3_bucket.admin-mou-bucket.arn}/*"]
    },{
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": ["${aws_s3_bucket.admin-mou-bucket.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl"
      ],
      "Resource": ["${aws_s3_bucket.product-page-data-bucket.arn}/*"]
    }
  ]
}
EOF
}
