resource "aws_iam_role_policy" "ecs-instance-policy" {
  name = "${var.aws-region-name}-frontend-ecs-instance-policy-${var.Env-Name}"
  role = "${aws_iam_role.ecs-instance-role.id}"

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
  name  = "${var.aws-region-name}-frontend-ecs-instance-profile-${var.Env-Name}"
  role  = "${aws_iam_role.ecs-instance-role.name}"
}

# Unused until a loadbalancer is set up
resource "aws_iam_role_policy" "ecs-service-policy" {
  name = "${var.aws-region-name}-frontend-ecs-service-policy-${var.Env-Name}"
  role = "${aws_iam_role.ecs-service-role.id}"

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
resource "aws_iam_role" "ecs-service-role" {
  name = "${var.aws-region-name}-frontend-ecs-service-role-${var.Env-Name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
