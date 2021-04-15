resource "aws_cloudwatch_log_group" "cloudwatch-alarm-pause-lambda" {
  name = "aws/lambda/log-group-for-cloudwatch-alarm-pause-lambda"

  tags = {
    Environment = "${var.Env-Name}"
  }
}




resource "aws_iam_role" "iam-role-for-cloudwatch-alarm-pause-lambda" {
  name = "iam-role-for-cloudwatch-pause-lambda"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:eu-west-2:${var.aws-account-id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-west-2:${var.aws-account-id}:log-group:/aws/lambda/log-group-for-cloudwatch-alarm-pause-lambda:*"
            ]
        }
    ]
}

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:eu-west-2:${var.aws-account-id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-west-2:${var.aws-account-id}:log-group:/aws/lambda/test-cloudwatch-alarm-disable:*"
            ]
        }
    ]
}
EOF
}


data "archive_file" "lambda-disable-cloudwatch-alarm" {
  type        = "zip"
  output_path = "${file("${path.module}/lambda_disable_cloudwatch_alarm.zip")}"
  source {
    content  = "${file("${path.module}/lambda_disable_cloudwatch_alarm.py")}"
    filename = "lambda_disable_cloudwatch_alarm.py"
  }
}

resource "aws_lambda_function" "disable-cloudwatch-alarm" {
    filename         = "${data.archive_file.lambda-disable-cloudwatch-alarm.output_path}"
    source_code_hash = "${data.archive_file.lambda-disable-cloudwatch-alarm.output_base64sha256}"
    function_name = "disable-cloudwatch-alarm"
    role = "${aws_iam_role.iam-role-for-cloudwatch-alarm-pause-lambda.id}"
}

resource "aws_cloudwatch_event_rule" "eleven-pm-trigger-rule" {
    name = "eleven-pm-trigger"
    description = "Runs at 11pm every night"
    schedule_expression = "rate(0 23 * * ? *)"
}

resource "aws_cloudwatch_event_target" "eleven-pm-trigger-target" {
    rule = "${aws_cloudwatch_event_rule.eleven-pm-trigger-rule.name}"
    target_id = "eleven-pm-trigger-target"
    arn = "${aws_lambda_function.disable-cloudwatch-alarm.arn}"
}

resource "aws_lambda_permission" "allow-cloudwatch-to-call-disable-cloudwatch-alarm" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.disable-cloudwatch-alarm.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.eleven-pm-trigger-rule.arn}"
}
