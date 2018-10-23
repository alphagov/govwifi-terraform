resource "aws_instance" "device-wifi-radius" {
  count                  = 1
  ami                    = "${var.ami}"
  instance_type          = "t2.medium"
  key_name               = "${var.ssh-key-name}"
  subnet_id              = "${var.subnet-id[0]}"
  vpc_security_group_ids = ["${var.radius-instance-sg-ids}"]
  iam_instance_profile   = "${var.ecs-instance-profile-id}"
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
# This cannot be moved to Ansible as it needs to exist when the instance is created
echo ECS_CLUSTER=${var.Env-Name}-device-wifi-frontend-cluster >> /etc/ecs/ecs.config

--==BOUNDARY==--
DATA

  tags {
    Name = "${title(var.Env-Name)} Device Wifi Frontend Radius-${var.dns-numbering-base + count.index + 1}"
    Env  = "${title(var.Env-Name)}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      "user_data"
    ]
  }
}

resource "aws_eip" "device-wifi-eip" {
  instance = "${aws_instance.device-wifi-radius.id}"
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id = "${aws_instance.device-wifi-radius.id}"
  allocation_id = "${aws_eip.device-wifi-eip.id}"
}
