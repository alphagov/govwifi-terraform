# Using custom ubuntu AMI id, as the micro size is only supported for paravirtual images.
resource "aws_instance" "management" {
  count         = var.enable-bastion
  ami           = var.bastion-ami
  instance_type = var.bastion-instance-type
  key_name      = var.bastion-ssh-key-name
  subnet_id     = aws_subnet.wifi-backend-subnet[0].id

  vpc_security_group_ids = [
    aws_security_group.be-vpn-in.id,
    aws_security_group.be-vpn-out.id,
    aws_security_group.be-ecs-out.id,
  ]

  iam_instance_profile = aws_iam_instance_profile.bastion-instance-profile[0].id
  monitoring           = var.enable-bastion-monitoring

  depends_on = [aws_iam_instance_profile.bastion-instance-profile]

  user_data = <<DATA
Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Wait for dpkg to be available
until [[ -z `sudo lsof /var/lib/dpkg/lock` ]] ; do echo -n "." >> /var/log/dpkg-wait.log; sleep 1; done
until [[ -z `sudo lsof /var/lib/apt/lists/lock` ]] ; do echo -n "." >> /var/log/apt-list-wait.log; sleep 1; done

# Fix for grub update bug https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1323772
sudo rm /boot/grub/menu.lst
sudo update-grub-legacy-ec2 -y

# Wait for dpkg to be available
until [[ -z `sudo lsof /var/lib/dpkg/lock` ]] ; do echo -n "." >> /var/log/dpkg-wait.log; sleep 1; done
until [[ -z `sudo lsof /var/lib/apt/lists/lock` ]] ; do echo -n "." >> /var/log/apt-list-wait.log; sleep 1; done
sudo apt-get update -q
until [[ -z `sudo lsof /var/lib/dpkg/lock` ]] ; do echo -n "." >> /var/log/dpkg-wait.log; sleep 1; done
until [[ -z `sudo lsof /var/lib/apt/lists/lock` ]] ; do echo -n "." >> /var/log/apt-list-wait.log; sleep 1; done
# Workaround, to skip failure to update libpam-systemd and libpam-runtime. Manual update may be required.
# See https://bugs.launchpad.net/ubuntu/+source/pam/+bug/682662
sudo apt-mark hold libpam-systemd:amd64 libpam-runtime
sudo apt-get upgrade -y -qq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
until [[ -z `sudo lsof /var/lib/dpkg/lock` ]] ; do echo -n "." >> /var/log/dpkg-wait.log; sleep 1; done
until [[ -z `sudo lsof /var/lib/apt/lists/lock` ]] ; do echo -n "." >> /var/log/apt-list-wait.log; sleep 1; done
sudo apt-get install -yq --autoremove \
    mysql-client \
    htop \
    mc \
    awscli

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
# Add extra users

oldIFS=$IFS
IFS='|' read -r -a userlist <<< "${join("|", var.users)}"
allowedUsers="ubuntu"

for credentials in "$${userlist[@]}"; do
  IFS=';' read -r -a credsarray <<< $credentials
  username="$${credsarray[0]}"
  sshkey="$${credsarray[1]}"

  sudo adduser "$username" --disabled-password --quiet --gecos ""
  sudo mkdir "/home/$username/.ssh"
  sudo chown "$username:$username" "/home/$username/.ssh"
  echo "$sshkey" > ./tempkey
  sudo mv ./tempkey "/home/$username/.ssh/authorized_keys"
  sudo chown "$username:$username" "/home/$username/.ssh/authorized_keys"
  sudo chmod 600 "/home/$username/.ssh/authorized_keys"

  allowedUsers="$allowedUsers $username"
done

IFS=$oldIFS

sudo sed -i -e "s/AllowUsers ubuntu/AllowUsers $allowedUsers/g" /etc/ssh/sshd_config
sudo sed -i -e "\$a Ciphers\ aes128-ctr,aes192-ctr,aes256-ctr" /etc/ssh/sshd_config
sudo /etc/init.d/ssh reload

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
# The install script requires the issue file to start with the string "Ubuntu"
sudo echo "Ubuntu Linux 20.04 LTS - Authorized uses only. All activity may be monitored and reported. \d \t @ \n" > /etc/issue
# Retrieve and run the install script
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
# Try to circumvent pip install error with waiting for 10 seconds.
sleep 10
sudo python3 ./awslogs-agent-setup.py -n -r ${var.aws-region} -c ./initial-awslogs.conf

--==BOUNDARY==--
DATA


  tags = {
    Name = "${title(var.Env-Name)} Bastion - backend (${aws_vpc.wifi-backend.id})"
    Env  = title(var.Env-Name)
  }
}

resource "aws_iam_role" "bastion-instance-role" {
  count = var.enable-bastion
  name  = "${var.aws-region-name}-${var.Env-Name}-backend-bastion-instance-role"

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
  count      = var.enable-bastion
  name       = "${var.aws-region-name}-${var.Env-Name}-backend-bastion-instance-policy"
  role       = aws_iam_role.bastion-instance-role[0].id
  depends_on = [aws_iam_role.bastion-instance-role]

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

resource "aws_iam_role_policy" "bastion-instance-policy-pp" {
  count = var.enable-bastion
  name  = "${var.aws-region-name}-${var.Env-Name}-backend-bastion-instance-policy"
  role  = aws_iam_role.bastion-instance-role[0].id
  depends_on = [
    aws_iam_role.bastion-instance-role
  ]

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
  count      = var.enable-bastion
  name       = "${var.aws-region-name}-${var.Env-Name}-backend-bastion-instance-profile"
  role       = aws_iam_role.bastion-instance-role[0].name
  depends_on = [aws_iam_role.bastion-instance-role]
}

resource "aws_eip_association" "eip_assoc" {
  count       = var.enable-bastion
  instance_id = aws_instance.management[0].id
  public_ip   = replace(var.bastion-server-ip, "/32", "")
}

resource "aws_cloudwatch_metric_alarm" "bastion_statusalarm" {
  count               = var.enable-bastion
  alarm_name          = "${lower(var.Env-Name)}-bastion-status-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  unit                = "Count"
  threshold           = "1"

  dimensions = {
    InstanceId = aws_instance.management[0].id
  }

  alarm_description  = "This metric monitors the status of the bastion server."
  alarm_actions      = [var.capacity-notifications-arn]
  treat_missing_data = "breaching"
}

