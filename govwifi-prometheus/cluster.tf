resource "aws_cloudwatch_log_group" "prometheus-log-group" {
  count         = "${var.create_prometheus_server}"
  name = "${var.Env-Name}-prometheus-log-group"
  retention_in_days = 90
}
