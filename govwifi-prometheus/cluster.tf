resource "aws_cloudwatch_log_group" "prometheus_log_group" {
  name              = "${var.Env-Name}-prometheus-log-group"
  retention_in_days = 90
}

