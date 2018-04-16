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
  function_name = "test_lambda"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "user_deletion.delete_old_users"
  runtime       = "python3.6"

  environment {
    variables = {
      DATABASE_HOST     = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
      DATABASE_USER     = "${var.db-user}"
      DATABASE_PASSWORD = "${var.db-password}"
      DATABASE          = "govwifi_${var.Env-Name}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = "every-five-minutes"
  description         = "Fires every five minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "delete_users_every_five_minutes" {
  rule      = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
  target_id = "test_lambda"
  arn       = "${aws_lambda_function.test_lambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_delete_users" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_five_minutes.arn}"
}
