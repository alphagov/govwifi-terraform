resource "aws_lambda_function" "user_deletion" {
  filename         = "user_deletion.zip"
  function_name    = "user_deletion"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "user_deletion.delete_old_users"
  source_code_hash = "${base64sha256(file("user_deletion.zip"))}"
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

resource "aws_lambda_function" "session_deletion" {
  filename         = "session_deletion.zip"
  function_name    = "session_deletion"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "session_deletion.delete_old_sessions"
  source_code_hash = "${base64sha256(file("session_deletion.zip"))}"
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
