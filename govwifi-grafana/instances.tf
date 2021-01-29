data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# The element() function used in subnets wraps around when the index is over the number of elements
# eg. in the 4th iteration the value returned will be the 1st, if there are only 3 elements in the list.
resource "aws_instance" "grafana_instance" {
  count         = "${var.create_grafana_server}"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  key_name      = "${var.ssh-key-name}"
  subnet_id     = "${element(var.backend-subnet-ids, count.index)}"
  user_data     = "${data.template_file.grafana_user_data.rendered}"

  vpc_security_group_ids = [
    "${var.be-admin-in}",
  ]

  tags = {
    Name = "${title(var.Env-Name)} Grafana-Server"
    Env  = "${title(var.Env-Name)}"
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      "user_data",
    ]
  }
}

data "template_file" "grafana_user_data" {}

resource "aws_ebs_volume" "grafana_ebs" {
  count             = "${var.create_grafana_server}"
  size              = 40
  encrypted         = true
  availability_zone = "${var.aws-region}a"

  tags = {
    Name = "${var.Env-Name} Grafana volume"
  }
}

resource "aws_volume_attachment" "grafana_ebs_attach" {
  count       = "${var.create_grafana_server}"
  depends_on  = ["aws_ebs_volume.grafana_ebs"]
  device_name = "/dev/xvdp"
  volume_id   = "${aws_ebs_volume.grafana_ebs.id}"
  instance_id = "${aws_instance.grafana_instance.id}"
}
