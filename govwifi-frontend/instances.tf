# The element() function used in subnets wraps around when the index is over the number of elements
# eg. in the 4th iteration the value returned will be the 1st, if there are only 3 elements in the list.
resource "aws_instance" "radius" {
  count                  = "${var.radius-instance-count}"
  ami                    = "${var.ami}"
  instance_type          = "t2.medium"
  key_name               = "${var.ssh-key-name}"
  subnet_id              = "${element(aws_subnet.wifi-frontend-subnet.*.id, count.index)}"
  vpc_security_group_ids = ["${var.radius-instance-sg-ids}"]
  iam_instance_profile   = "${aws_iam_instance_profile.ecs-instance-profile.id}"
  monitoring             = "${var.enable-detailed-monitoring}"

  user_data = <<DATA
Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-config; charset="us-ascii"
#cloud-config
repo_update: true
repo_upgrade: all

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
echo ECS_CLUSTER=${var.Env-Name}-frontend-cluster >> /etc/ecs/ecs.config

--==BOUNDARY==--
DATA

  tags {
    Name = "${title(var.Env-Name)} Frontend Radius-${var.dns-numbering-base + count.index + 1}"
    Env  = "${title(var.Env-Name)}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      "user_data"
    ]
  }
}

resource "aws_eip_association" "eip_assoc" {
  count       = "${var.radius-instance-count}"
  instance_id = "${element(aws_instance.radius.*.id, count.index)}"
  public_ip   = "${replace(element(var.elastic-ip-list, count.index), "/32", "")}"
}
