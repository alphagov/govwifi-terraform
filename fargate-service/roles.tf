locals {
  has-custom-container-policy = "${var.container-policy-arn != ""}"
}

resource "aws_iam_role" "container" {
  # Role exposed to the container
  name               = "${local.full-name}-container-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
  tags               = "${local.staged-tags}"
}

resource "aws_iam_role" "execution" {
  # Role exposed to the agent launching the container
  name               = "${local.full-name}-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
  tags               = "${local.staged-tags}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  # This is managed by AWS
  role       = "${aws_iam_role.execution.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "provided" {
  count      = "${local.has-custom-container-policy ? 1 : 0}"
  role       = "${aws_iam_role.container.name}"
  policy_arn = "${var.container-policy-arn}"
}
