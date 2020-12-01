/**
I'm not sure we need to create a specific prometheus subnet.
resource "aws_subnet" "prometheus-subnet" {
  vpc_id                  = "${var.frontend-vpc-id}"
  availability_zone       = "${var.aws-region}"
  cidr_block              = "${lookup(var.zone-subnets, "zone0")}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.Env-Name} Prometheus - AZ: ${lookup(var.zone-subnets, "zone0")} - GovWifi subnet"
  }
}
**/

# Create New EIP and Associate it
# Temporarily commenting this out since we can't release/delete EIPs. So when
# terraform runs it will error
# resource "aws_eip" "prometheus_eip" {
#   instance = "${aws_instance.prometheus_instance.id}"
#   vpc      = true
#
#   tags = {
#     Name = "${title(var.Env-Name)} Prometheus-Server"
#     Env  = "${title(var.Env-Name)}"
#   }
#
# }

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


data "template_file" "prometheus_user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars = {
     data_volume_size           = "${var.prometheus_volume_size}"
     prometheus-log-group       = "${var.Env-Name}-prometheus-log-group"
     prometheus_config          = "${data.template_file.prometheus_config.rendered}"
  }
}

data "template_file" "prometheus_config" {
  template = "${file("${path.module}/prometheus.yml")}"
  # count    = "${length(var.london-radius-ip-addresses)}"
  #
  # vars = {
  #   london-radius-ip-addresses = "${element(values(var.london-radius-ip-addresses[count.index]), 0)}"
  # }
}

# The element() function used in subnets wraps around when the index is over the number of elements
# eg. in the 4th iteration the value returned will be the 1st, if there are only 3 elements in the list.
resource "aws_instance" "prometheus_instance" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  key_name      = "${var.ssh-key-name}"
  subnet_id     = "${element(var.wifi-frontend-subnet, count.index)}" // referred to the existing wifi subnet instead of creating a new one
  user_data     = "${data.template_file.prometheus_user_data.rendered}"

### Editing begins again HERE!!!
  vpc_security_group_ids = [
    "${var.fe-ecs-out}",
    "${var.fe-admin-in}",
    "${var.fe-radius-out}",
    "${var.fe-radius-in}",
  ]

  //iam_instance_profile = "${var.ecs_instance_profile}"
  //Commented the above out for now, lets worry about adding this to a cluster later

  // Do we need detailed monitoring enabled?
  //  monitoring           = "${var.enable-detailed-monitoring}"

//  Verify have a cloudinit: https://github.com/alphagov/verify-infrastructure/terraform/modules/hub/files/cloud-init/prometheus.sh
//  user_data = ""

  tags = {
    Name = "${title(var.Env-Name)} Prometheus-Server" // previously had ${var.dns-numbering-base} but I don't think we need this
    Env  = "${title(var.Env-Name)}"
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      "user_data",
    ]
  }
}

### ADD A VOLUME FOR PROMETHEUS

resource "aws_ebs_volume" "prometheus_ebs" {

  size      = 40
  encrypted = true
  availability_zone       = "${var.aws-region}"

  tags = {
    Name = "Prometheus volume"
  }
}

resource "aws_volume_attachment" "prometheus_ebs_attach" {
  device_name = "/dev/xvdp"
  volume_id   = "${aws_ebs_volume.prometheus_ebs.id}"
  instance_id = "${aws_instance.prometheus_instance.id}"
}

# resource "aws_eip_association" "prometheus_eip_assoc" {
#   instance_id   = aws_instance.prometheus_instance.id
#   allocation_id = "${var.prometheus_eip.id}"  aws_eip.example.id
# }

resource "aws_eip_association" "prometheus_eip_assoc" {
  instance_id   = "${aws_instance.prometheus_instance.id}"
  public_ip     = "${var.prometheus_eip}"
}
