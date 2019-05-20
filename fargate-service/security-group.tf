locals {
  security-group-service-port-keys = "${keys(var.ports)}"
}

resource "aws_security_group" "service" {
  name_prefix = "${local.full-name}-service"
  vpc_id      = "${var.vpc-id}"
  tags        = "${local.staged-tags}"
}

resource "aws_security_group" "lb" {
  name_prefix = "${local.full-name}-lb"
  vpc_id      = "${var.vpc-id}"
  tags        = "${local.staged-tags}"
}

resource "aws_security_group_rule" "service-egress" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  security_group_id = "${aws_security_group.service.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "all"
  from_port         = 0
  to_port           = 0
}

resource "aws_security_group_rule" "service-ingress" {
  count                    = "${length(local.security-group-service-port-keys)}"
  type                     = "ingress"
  description              = "Allow traffic from the loadbalancer to the service"
  security_group_id        = "${aws_security_group.service.id}"
  source_security_group_id = "${aws_security_group.lb.id}"
  protocol                 = "${var.ports[element(local.security-group-service-port-keys, count.index)]}"
  from_port                = "${element(local.security-group-service-port-keys, count.index)}"
  to_port                  = "${element(local.security-group-service-port-keys, count.index)}"
}

resource "aws_security_group_rule" "lb-ingress-http" {
  count             = "${local.public-loadbalancer ? 1 : 0}"
  type              = "ingress"
  description       = "Allow HTTP traffic to the loadbalancer"
  security_group_id = "${aws_security_group.lb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  from_port         = "80"
  to_port           = "80"
}

resource "aws_security_group_rule" "lb-ingress-https" {
  count             = "${local.public-loadbalancer ? 1 : 0}"
  type              = "ingress"
  description       = "Allow HTTPS traffic to the loadbalancer"
  security_group_id = "${aws_security_group.lb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  from_port         = "443"
  to_port           = "443"
}

resource "aws_security_group_rule" "lb-egress" {
  count                    = "${length(local.security-group-service-port-keys)}"
  type                     = "egress"
  description              = "Allow Loadbalancer to send to Service"
  security_group_id        = "${aws_security_group.lb.id}"
  source_security_group_id = "${aws_security_group.service.id}"
  protocol                 = "${var.ports[element(local.security-group-service-port-keys, count.index)]}"
  from_port                = "${element(local.security-group-service-port-keys, count.index)}"
  to_port                  = "${element(local.security-group-service-port-keys, count.index)}"
}
