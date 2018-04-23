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

resource "aws_iam_policy_attachment" "lambda-execute-policy-attachment" {
  name       = "Lamba cloudwatch and VPC execution policy"
  roles      = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "deletion-payload.zip"
  function_name = "test_lambda"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "user_deletion.delete_old_users"
  runtime       = "python3.6"

  vpc_config {
    security_group_ids = ["${var.db-sg-list}"]
    subnet_ids         = ["${var.db-subnet-ids}"]
  }

  environment {
    variables = {
      DATABASE_HOST     = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
      DATABASE_USER     = "${var.db-user}"
      DATABASE_PASSWORD = "${var.db-password}"
      DATABASE          = "govwifi_${var.Env-Name}"
    }
  }
}

resource "aws_lambda_function" "user_deletion" {
  filename         = "deletion-payload.zip"
  function_name    = "user_deletion"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "user_deletion.delete_old_users"
  source_code_hash = "${base64sha256(file("deletion-payload.zip"))}"
  runtime          = "python3.6"

  vpc_config {
    security_group_ids = ["${var.db-sg-list}"]
    subnet_ids         = ["${var.db-subnet-ids}"]
  }

  environment {
    variables = {
      DATABASE_HOST     = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
      DATABASE_USER     = "${var.db-user}"
      DATABASE_PASSWORD = "${var.db-password}"
      DATABASE          = "govwifi_${var.Env-Name}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_morning_at_one" {
  name                = "every-morning-at-one"
  description         = "Triggers every morning at 1AM"
  schedule_expression = "cron(0 1 * * ? *)"
}

resource "aws_cloudwatch_event_target" "delete_users_every_morning_at_one" {
  rule      = "${aws_cloudwatch_event_rule.every_morning_at_one.name}"
  target_id = "user_deletion"
  arn       = "${aws_lambda_function.user_deletion.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_delete_users" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.user_deletion.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_morning_at_one.arn}"
}
