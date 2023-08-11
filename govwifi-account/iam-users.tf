resource "aws_iam_user" "monitoring_stats_user" {
  name          = "monitoring-stats-user"
  path          = "/"
  force_destroy = false
}
