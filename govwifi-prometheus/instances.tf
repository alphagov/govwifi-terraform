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
resource "aws_instance" "prometheus_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.small"
  key_name      = var.ssh_key_name
  subnet_id     = var.wifi_frontend_subnet[0]
  user_data = templatefile("${path.module}/user_data.sh",
    {
      data_volume_size     = var.prometheus_volume_size,
      prometheus-log-group = "${var.env_name}-prometheus-log-group",
      prometheus_config = templatefile("${path.module}/prometheus.yml",
        {
          london-radius-ip-addresses-one   = element(var.london_radius_ip_addresses, 0),
          london-radius-ip-addresses-two   = element(var.london_radius_ip_addresses, 1),
          london-radius-ip-addresses-three = element(var.london_radius_ip_addresses, 2),
          dublin-radius-ip-addresses-one   = element(var.dublin_radius_ip_addresses, 0),
          dublin-radius-ip-addresses-two   = element(var.dublin_radius_ip_addresses, 1),
          dublin-radius-ip-addresses-three = element(var.dublin_radius_ip_addresses, 2)
        }
      ),
      prometheus_startup = templatefile("${path.module}/prometheus-govwifi", {})
    }
  )
  disable_api_termination = false
  ebs_optimized           = false
  monitoring              = false

  vpc_security_group_ids = [
    aws_security_group.prometheus.id,
    var.fe_admin_in,
  ]

  iam_instance_profile = aws_iam_instance_profile.prometheus_instance_profile.id

  tags = {
    Name = "${title(var.env_name)} Prometheus-Server"
    Env  = title(var.env_name)
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [user_data, volume_tags]
  }
}

resource "aws_ebs_volume" "prometheus_ebs" {
  size              = 40
  encrypted         = true
  availability_zone = aws_instance.prometheus_instance.availability_zone

  tags = {
    Name = "${var.env_name} Prometheus volume"
  }
}

resource "aws_volume_attachment" "prometheus_ebs_attach" {
  depends_on  = [aws_ebs_volume.prometheus_ebs]
  device_name = "/dev/xvdp"
  volume_id   = aws_ebs_volume.prometheus_ebs.id
  instance_id = aws_instance.prometheus_instance.id
}

resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "prometheus"
    Env  = title(var.env_name)
  }
}

resource "aws_eip_association" "prometheus_eip_assoc" {
  instance_id   = aws_instance.prometheus_instance.id
  allocation_id = aws_eip.eip.id
}

