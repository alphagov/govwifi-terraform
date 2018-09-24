resource "aws_ecs_cluster" "api-cluster" {
  name = "${var.Env-Name}-${var.aws-region}-api-cluster"
}
