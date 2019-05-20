resource "aws_cloudwatch_log_group" "this" {
  name              = "${local.full-name}"
  tags              = "${local.staged-tags}"
  retention_in_days = "90"
}
