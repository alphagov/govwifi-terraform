resource "aws_iam_role" "iam_for_lambda" {
  name = "user-signup-api-sns-lambda"

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

resource "aws_lambda_function" "usersignup_sns_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "govwifi_sns_to_usersignup"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.py"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.8"

  tags = {
    Environment = "${var.env_name}"
  }

}

resource "aws_sns_topic_subscription" "user_updates_lampda_target" {
  topic_arn = "sns topic arn"
  protocol  = "lambda"
  endpoint  = "lambda arn here"
}
