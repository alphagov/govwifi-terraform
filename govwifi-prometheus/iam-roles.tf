resource "aws_iam_instance_profile" "prometheus-instance-profile" {
  // count      = var.enable-bastion
  name       = "${var.aws-region}-${var.Env-Name}-prometheus-instance-profile"
  role       = aws_iam_role.prometheus-instance-role.name
  // depends_on = [aws_iam_role.prometheus-instance-role]
}


resource "aws_iam_role" "prometheus-instance-role" {
  // count = var.enable-prometheus
  name  = "${var.aws-region}-${var.Env-Name}-prometheus-instance-role"
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

resource "aws_iam_role_policy" "prometheus-instance-policy" {
  // count      = min(1 - var.save-pp-data, var.enable-bastion)  ???
  name       = "${var.aws-region}-${var.Env-Name}-prometheus-instance-policy"
  role       = aws_iam_role.prometheus-instance-role.id
  // depends_on = [aws_iam_role.prometheus-instance-role]

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

