resource "aws_ecs_cluster" "api-cluster" {
  name = "${var.Env-Name}-api-cluster"
}
