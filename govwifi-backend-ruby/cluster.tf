resource "aws_ecs_cluster" "backend-ruby-cluster" {
  name = "${var.Env-Name}-backend-ruby-cluster"
}
