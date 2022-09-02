resource "aws_sns_topic" "smoke_tests" {
  name = "govwifi-smoke-tests"
}

resource "aws_cloudwatch_event_rule" "smoke_tests" {
  name        = "smoke-tests-notification"
  description = "Capture any failed smoke-tests and notify smoke-tests sns topic"

  event_pattern = <<EOF
{
  "source": ["aws.codebuild"],
  "detail-type": ["CodeBuild Build State Change"],
  "detail": {
    "build-status": ["FAILED"],
    "project-name": ["govwifi-smoke-tests"]
  }
}
EOF

}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.smoke_tests.name
  target_id = "SendSmoketestsToSNS"
  arn       = aws_sns_topic.smoke_tests.arn

  input_transformer {
    input_paths = {
      build-id = "$.detail.build-id",
    }

    input_template = "\"Smoke Test Failure: <build-id>\""
  }
}
