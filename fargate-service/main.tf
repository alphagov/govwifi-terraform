provider "template" {
  version = "~> 2.1"
}

data "aws_region" "current" {}

data "aws_subnet_ids" "this" {
  vpc_id = "${var.vpc-id}"
}

resource "aws_ecs_cluster" "this" {
  count = "${local.create_cluster ? 1 : 0}"
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
  desired_count   = "${var.instance-count}"
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.admin-tg.arn}"
    container_name   = "${var.name}"
    container_port   = "3000"
  }

  network_configuration {
    subnets = ["${local.subnet-ids}"]

    security_groups = [
      "${aws_security_group.admin-ec2-in.id}",
      "${aws_security_group.admin-ec2-out.id}",
    ]

    assign_public_ip = true
  }
}
