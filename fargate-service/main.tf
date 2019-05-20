provider "template" {
  version = "~> 2.1"
}

data "aws_region" "current" {}

data "aws_subnet_ids" "this" {
  vpc_id = "${var.vpc-id}"
}

resource "aws_ecs_cluster" "this" {
  count = "${local.create-cluster ? 1 : 0}"
  name  = "${local.full-name}"
  tags  = "${local.staged-tags}"
}

resource "aws_ecr_repository" "this" {
  count = "${local.create-repository ? 1 : 0}"
  name  = "${var.namespace}/${var.name}"
  tags  = "${local.tags}"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${local.full-name}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"
  network_mode             = "awsvpc"
  container_definitions    = "${local.container-definition}"
}

resource "aws_ecs_service" "this" {
  cluster         = "${local.cluster-id}"
  name            = "${local.full-name}"
  tags            = "${local.tags}"
  task_definition = "${aws_ecs_task_definition.this.arn}"
  desired_count   = "${local.desired-count}"
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.this.arn}"
    container_name   = "${var.name}"
    container_port   = "${local.forwarding-port}"
  }

  network_configuration {
    subnets = [
      "${local.subnet-ids}",
    ]

    security_groups = [
      "${aws_security_group.service.id}",
    ]

    assign_public_ip = true
  }
}
