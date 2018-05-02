resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_${var.Env-Name}-${lower(var.aws-region-name)}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda-execute-policy-attachment" {
  name       = "Lamba cloudwatch and VPC execution policy"
  roles      = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
