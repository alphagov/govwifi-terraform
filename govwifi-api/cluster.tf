resource "aws_ecs_cluster" "api_cluster" {
  name = "${var.Env-Name}-api-cluster"
}

