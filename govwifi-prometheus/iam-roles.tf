resource "aws_iam_instance_profile" "prometheus_instance_profile" {
  name = "${var.aws-region}-${var.Env-Name}-prometheus-instance-profile"
  role = aws_iam_role.prometheus_instance_role.name
}

resource "aws_iam_role" "prometheus_instance_role" {
  name = "${var.aws-region}-${var.Env-Name}-prometheus-instance-role"
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

resource "aws_iam_role_policy" "prometheus_instance_policy" {
  name = "${var.aws-region}-${var.Env-Name}-prometheus-instance-policy"
  role = aws_iam_role.prometheus_instance_role.id

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

