data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210315"]
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
  count                   = var.create_grafana_server
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.small"
  key_name                = var.ssh-key-name
  subnet_id               = element(var.backend-subnet-ids, count.index)
  user_data               = data.template_file.grafana_user_data.rendered
  disable_api_termination = false
  ebs_optimized           = false

  vpc_security_group_ids = [
    var.be-admin-in,
    aws_security_group.grafana-ec2-in.id,
    aws_security_group.grafana-ec2-out.id,
  ]

  iam_instance_profile = aws_iam_instance_profile.grafana-instance-profile.id

  tags = {
    Name = "${title(var.Env-Name)} Grafana-Server"
    Env  = title(var.Env-Name)
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [user_data, volume_tags]
  }
}

resource "aws_ebs_volume" "grafana_ebs" {
  count             = var.create_grafana_server
  size              = 40
  encrypted         = true
  availability_zone = "${var.aws-region}a"

  tags = {
    Name = "${var.Env-Name} Grafana volume"
  }
}

resource "aws_volume_attachment" "grafana_ebs_attach" {
  count       = var.create_grafana_server
  depends_on  = [aws_ebs_volume.grafana_ebs]
  device_name = var.grafana-device-name
  volume_id   = aws_ebs_volume.grafana_ebs[0].id
  instance_id = aws_instance.grafana_instance[0].id
}

data "template_file" "grafana_user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    grafana-log-group       = "${var.Env-Name}-grafana-log-group"
    grafana_admin           = local.grafana-admin
    google_client_secret    = local.google-client-secret
    google_client_id        = local.google-client-id
    grafana_server_root_url = local.grafana-server-root-url
    grafana_device_name     = var.grafana-device-name
    grafana_docker_version  = var.grafana-docker-version
  }
}

