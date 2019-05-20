locals {
  full-name      = "${var.namespace}-${var.name}-${var.stage}"
  create-cluster = "${var.cluster-id == ""}"
  cluster-id     = "${local.create-cluster ? aws_ecs_cluster.this.id : var.cluster-id}"

  create-repository = "${var.repository == ""}"
  repository        = "${local.create-repository ? aws_ecr_repository.this.repository_url : var.repository}"
  image             = "${local.repository}:${var.image-tag}"

  # This is an absolute hack, due to lists not being supported well in locals
  subnet-ids    = "${split("&", length(var.subnet-ids) == 0 ? join("&", data.aws_subnet_ids.this.ids) : join("&", var.subnet-ids))}"
  desired-count = "${var.count-per-subnet * length(local.subnet-ids)}"

  create-loadbalancer = "${var.loadbalancer-arn == ""}"
  public-loadbalancer = "${local.create-loadbalancer && var.public-loadbalancer}"
  loadbalancer-arn    = "${local.create-loadbalancer ? aws_lb.this.arn : var.loadbalancer-arn}"

  create-dns-record = "${var.hosted-zone-id != ""}"

  healthchecks-enabled = "${var.healthcheck-path != ""}"

  forwarding-port = "${
    var.forwarding-port != ""
    ? var.forwarding-port
    : length(var.ports) == 1
      ? element(keys(var.ports), 0)
      : ""
  }"

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
