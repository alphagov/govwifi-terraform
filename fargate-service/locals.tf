locals {
  full-name      = "${var.namespace}-${var.name}-${var.stage}"
  create-cluster = "${var.cluster-id == ""}"
  cluster-id     = "${local.create-cluster ? aws_ecs_cluster.this.id : var.cluster-id}"

  create-repository = "${var.repository == ""}"
  repository        = "${local.create-repository ? "" : var.repository}"
  image             = "${local.repository}:${var.image-tag}"

  subnet-ids    = "${var.subnet-ids == "" ? data.aws_subnet_ids.this.ids : var.subnet-ids }"
  desired-count = "${var.count-per-subnet * local.subnet-ids}"

  default-tags = {
    "Namespace" = "${var.namespace}"
    "Service"   = "${var.name}"
  }

  tags = "${merge(local.default-tags, var.tags)}"

  staged-tags = "${merge(
    local.default-tags,
    map("Stage", var.stage),
    var.tags
  )}"
}
