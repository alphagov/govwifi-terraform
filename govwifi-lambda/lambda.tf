resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "test_lambda" {
  filename      = "deletion-payload.zip"
  function_name = "Deletion Spike"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "user_deletion.delete_old_users"
  runtime       = "python3"

  environment {
    variables = {
      DATABASE_HOST     = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
      DATABASE_USER     = "${var.db-user}"
      DATABASE_PASSWORD = "${var.db-password}"
      DATABASE          = "govwifi_${var.Env-Name}"
    }
  }
}
