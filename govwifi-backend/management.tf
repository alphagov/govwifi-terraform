# Using custom ubuntu AMI id, as the micro size is only supported for paravirtual images.
resource "aws_instance" "management" {
  ami                    = "${var.bastion-ami}"
  instance_type          = "${var.bastion-instance-type}"
  key_name               = "${var.ssh-key-name}"
  subnet_id              = "${aws_subnet.wifi-backend-subnet.0.id}"
  vpc_security_group_ids = ["${var.mgt-sg-list}"]
  iam_instance_profile   = "${aws_iam_instance_profile.bastion-instance-profile.id}"
  monitoring             = "${var.enable-bastion-monitoring}"

  depends_on = [
    "aws_iam_instance_profile.bastion-instance-profile",
  ]

  user_data = <<DATA
Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
sudo apt-get update \
  && sudo apt-get -y upgrade \
  && sudo apt-get -y install \
    unattended-upgrades \
    mysql-client \
    curl \
    htop \
    vim

# Allow auto-updates for everything, not just security
sudo sed -i -e 's/\/\/\t"$${distro_id}:$${distro_codename}-updates";/\t"$${distro_id}:$${distro_codename}-updates";/g' /etc/apt/apt.conf.d/50unattended-upgrades
# Install updates in the background while the machine is running
sudo sed -i -e 's/\/\/Unattended-Upgrade::InstallOnShutdown "true";/Unattended-Upgrade::InstallOnShutdown "false";/g' /etc/apt/apt.conf.d/50unattended-upgrades
# Reboot automatically (and instantly) when required
sudo sed -i -e 's/\/\/Unattended-Upgrade::Automatic-Reboot "false";/Unattended-Upgrade::Automatic-Reboot "true";/g' /etc/apt/apt.conf.d/50unattended-upgrades

# Set up periodic run of upgrades
cat <<'EOF' > ./periodic-updates-setup
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF
sudo cp ./periodic-updates-setup /etc/apt/apt.conf.d/10periodic

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set up cron scripts for timed jobs

cat <<'EOF' > ./ping-survey
#!/bin/bash
wget http://elb.${lower(var.aws-region-name)}.${var.Env-Name}${var.Env-Subdomain}.service.gov.uk/timedjobs/survey?key=${var.shared-key}
EOF

cat <<'EOF' > ./ping-performanceplatform
#!/bin/bash
wget http://elb.${lower(var.aws-region-name)}.${var.Env-Name}${var.Env-Subdomain}.service.gov.uk/timedjobs/performanceplatform?key=${var.shared-key}
EOF

cat <<'EOF' > ./ping-performanceplatform-weekly
#!/bin/bash
wget "http://elb.${lower(var.aws-region-name)}.${var.Env-Name}${var.Env-Subdomain}.service.gov.uk/timedjobs/performanceplatform?key=${var.shared-key}&period=weekly"
EOF

chmod +x ./ping-survey ./ping-performanceplatform ./ping-performanceplatform-weekly
sudo cp ./ping-survey /etc/cron.hourly/
sudo cp ./ping-performanceplatform /etc/cron.daily/
sudo cp ./ping-performanceplatform-weekly /etc/cron.weekly/

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Inject the CloudWatch Logs configuration file contents
sudo cat <<'EOF' > ./initial-awslogs.conf
[general]
state_file = /var/awslogs/state/agent-state

[/var/log/syslog]
file = /var/log/syslog
log_group_name = ${var.Env-Name}-bastion/var/log/syslog
log_stream_name = {instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/auth.log]
file = /var/log/auth.log
log_group_name = ${var.Env-Name}-bastion/var/log/auth.log
log_stream_name = {instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = ${var.Env-Name}-bastion/var/log/dmesg
log_stream_name = {instance_id}

[/var/log/unattended-upgrades/unattended-upgrades.log]
file = /var/log/unattended-upgrades/unattended-upgrades.log
log_group_name = ${var.Env-Name}-bastion/var/log/unattended-upgrades/unattended-upgrades.log
log_stream_name = {instance_id}
datetime_format = %Y-%m-%d %H:%M:%S

[/var/log/cloud-init-output.log]
file = /var/log/cloud-init-output.log
log_group_name = ${var.Env-Name}-bastion/var/log/cloud-init-output.log
log_stream_name = {instance_id}

EOF

# Install awslogs
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
chmod +x ./awslogs-agent-setup.py
sudo ./awslogs-agent-setup.py -n -r ${var.aws-region} -c ./initial-awslogs.conf

--==BOUNDARY==--
DATA

  tags {
    Name = "${title(var.Env-Name)} Bastion - backend (${aws_vpc.wifi-backend.id})"
  }
}

resource "aws_iam_role" "bastion-instance-role" {
  name = "${var.aws-region-name}-${var.Env-Name}-backend-bastion-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bastion-instance-policy" {
  name       = "${var.aws-region-name}-${var.Env-Name}-backend-bastion-instance-policy"
  role       = "${aws_iam_role.bastion-instance-role.id}"
  depends_on = ["aws_iam_role.bastion-instance-role"]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bastion-instance-profile" {
  name       = "${var.aws-region-name}-${var.Env-Name}-backend-bastion-instance-profile"
  role       = "${aws_iam_role.bastion-instance-role.name}"
  depends_on = ["aws_iam_role.bastion-instance-role"]
}

resource "aws_eip_association" "eip_assoc" {
  instance_id = "${aws_instance.management.id}"
  public_ip   = "${replace(var.bastion-server-ip, "/32", "")}"
}
