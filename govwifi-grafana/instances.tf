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
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.small"
  key_name      = var.ssh_key_name
  subnet_id     = var.backend_subnet_ids[0]
  user_data = templatefile("${path.module}/user_data.sh",
    {
      grafana-log-group       = "${var.env_name}-grafana-log-group",
      grafana_admin           = local.grafana_admin,
      google_client_secret    = local.google_client_secret,
      google_client_id        = local.google_client_id,
      grafana_server_root_url = local.grafana_server_root_url,
      grafana_device_name     = var.grafana_device_name,
      grafana_docker_version  = var.grafana_docker_version
    }
  )

  disable_api_termination = false
  ebs_optimized           = false

  vpc_security_group_ids = [
    var.be_admin_in,
    aws_security_group.grafana_ec2_in.id,
    aws_security_group.grafana_ec2_out.id,
  ]

  iam_instance_profile = aws_iam_instance_profile.grafana_instance_profile.id

  tags = {
    Name = "${title(var.env_name)} Grafana-Server"
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [user_data, volume_tags]
  }
}

resource "aws_ebs_volume" "grafana_ebs" {
  size              = 40
  encrypted         = true
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.env_name} Grafana volume"
  }
}

resource "aws_volume_attachment" "grafana_ebs_attach" {
  depends_on  = [aws_ebs_volume.grafana_ebs]
  device_name = var.grafana_device_name
  volume_id   = aws_ebs_volume.grafana_ebs.id
  instance_id = aws_instance.grafana_instance.id
}
