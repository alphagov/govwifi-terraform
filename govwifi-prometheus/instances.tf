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

data "template_file" "prometheus_user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    data_volume_size     = var.prometheus_volume_size
    prometheus-log-group = "${var.Env-Name}-prometheus-log-group"
    prometheus_config    = data.template_file.prometheus_config.rendered
    prometheus_startup   = data.template_file.prometheus_startup.rendered
  }
}

data "template_file" "prometheus_config" {
  template = file("${path.module}/prometheus.yml")

  vars = {
    london-radius-ip-addresses-one   = element(var.london-radius-ip-addresses, 0)
    london-radius-ip-addresses-two   = element(var.london-radius-ip-addresses, 1)
    london-radius-ip-addresses-three = element(var.london-radius-ip-addresses, 2)
    dublin-radius-ip-addresses-one   = element(var.dublin-radius-ip-addresses, 0)
    dublin-radius-ip-addresses-two   = element(var.dublin-radius-ip-addresses, 1)
    dublin-radius-ip-addresses-three = element(var.dublin-radius-ip-addresses, 2)
  }
}

data "template_file" "prometheus_startup" {
  template = file("${path.module}/prometheus-govwifi")
}

# The element() function used in subnets wraps around when the index is over the number of elements
# eg. in the 4th iteration the value returned will be the 1st, if there are only 3 elements in the list.
resource "aws_instance" "prometheus_instance" {
  count                   = var.create_prometheus_server
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.small"
  key_name                = var.ssh-key-name
  subnet_id               = element(var.wifi-frontend-subnet, count.index)
  user_data               = data.template_file.prometheus_user_data.rendered
  disable_api_termination = false
  ebs_optimized           = false
  monitoring              = false

  vpc_security_group_ids = [
    var.fe-ecs-out,
    var.fe-admin-in,
    var.fe-radius-out,
    var.fe-radius-in,
    aws_security_group.grafana-data-in.id,
  ]

  tags = {
    Name = "${title(var.Env-Name)} Prometheus-Server"
    Env  = title(var.Env-Name)
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [user_data, volume_tags]
  }
}

resource "aws_ebs_volume" "prometheus_ebs" {
  count             = var.create_prometheus_server
  size              = 40
  encrypted         = true
  availability_zone = "${var.aws-region}a"

  tags = {
    Name = "${var.Env-Name} Prometheus volume"
  }
}

resource "aws_volume_attachment" "prometheus_ebs_attach" {
  count       = var.create_prometheus_server
  depends_on  = [aws_ebs_volume.prometheus_ebs]
  device_name = "/dev/xvdp"
  volume_id   = aws_ebs_volume.prometheus_ebs[0].id
  instance_id = aws_instance.prometheus_instance[0].id
}

resource "aws_eip_association" "prometheus_eip_assoc" {
  count       = var.create_prometheus_server
  depends_on  = [aws_instance.prometheus_instance]
  instance_id = aws_instance.prometheus_instance[0].id
  public_ip   = var.prometheus-IP
}

