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
resource "aws_eip" "prometheus-eip" {
  instance = "${aws_instance.prometheus-instance.id}"
  vpc      = true
}

# The element() function used in subnets wraps around when the index is over the number of elements
# eg. in the 4th iteration the value returned will be the 1st, if there are only 3 elements in the list.
resource "aws_instance" "prometheus-instance" {
  ami           = "${var.ami}"
  instance_type = "t2.small"
  key_name      = "${var.ssh-key-name}"
  subnet_id     = "${element(var.wifi-frontend-subnet, count.index)}" // referred to the existing wifi subnet instead of creating a new one


### Editing begins again HERE!!!
  vpc_security_group_ids = [
    "${var.fe-ecs-out}",
    "${var.fe-admin-in}",
    "${var.fe-radius-out}",
    "${var.fe-radius-in}",
  ]

  iam_instance_profile = "${var.ecs-instance-profile}"

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
