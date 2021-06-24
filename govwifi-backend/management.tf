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
# Set up cron scripts for timed jobs

cat <<'EOF' > ./backup-performanceplatform
#!/bin/bash

today=`date  +"%F"`
mkdir pp-backup-tmp

wget -O pp-backup-tmp/account-usage.json "https://${var.pp-domain-name}/data/gov-wifi/account-usage?collect=count%3Asum&group_by=type&period=day&filter_by=dataType%3Aaccount-usage&start_at=2016-11-01T00%3A00%3A00Z&end_at="$today"T10%3A55%3A06Z&format=json"
wget -O pp-backup-tmp/number-of-transactions.json "https://${var.pp-domain-name}/data/gov-wifi/account-usage?flatten=true&collect=count%3Asum&group_by=dataType&filter_by=type%3Atransactions&format=json"
wget -O pp-backup-tmp/registrations-volumetrics.json "https://${var.pp-domain-name}/data/gov-wifi/volumetrics?collect=cumulative_count%3Amean&group_by=channel&start_at=2016-08-01T00%3A00%3A00Z&period=day&end_at="$today"T11%3A49%3A25Z&format=json"
wget -O pp-backup-tmp/number-of-registrations.json "https://${var.pp-domain-name}/data/gov-wifi/volumetrics?flatten=true&sort_by=_timestamp%3Adescending&limit=1&filter_by=channel%3Aall-sign-ups&format=json"
wget -O pp-backup-tmp/unique-users-week.json "https://${var.pp-domain-name}/data/gov-wifi/unique-users?flatten=true&collect=count%3Asum&start_at=2016-11-01T00%3A00%3A00Z&period=week&end_at="$today"T11%3A53%3A49Z&format=json"
wget -O pp-backup-tmp/unique-users-month.json "https://${var.pp-domain-name}/data/gov-wifi/unique-users?flatten=true&collect=month_count%3Asum&start_at=2016-11-01T00%3A00%3A00Z&period=month&end_at="$today"T11%3A54%3A38Z&format=json"
wget -O pp-backup-tmp/completion-rate.json "https://${var.pp-domain-name}/data/gov-wifi/completion-rate?flatten=true&collect=count%3Asum&group_by=stage&period=week&start_at=2016-10-31T00%3A00%3A00Z&end_at="$today"T23%3A59%3A59Z&format=json"

aws s3 cp pp-backup-tmp s3://${var.Env-Name}-${lower(var.aws-region-name)}-pp-data/ --recursive --region ${var.aws-region}

rm -r pp-backup-tmp
EOF


chmod +x ./backup-performanceplatform
mkdir /home/ubuntu/backup
sudo cp ./backup-performanceplatform /home/ubuntu/backup/

if [ 1 == ${var.save-pp-data} ] ; then
  sudo cp ./backup-performanceplatform /etc/cron.daily/
fi

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
# Steps required are install pre-reqs for python 3.5.n, install & build python 3.5 cos awslogs script only supports python < 3.5
# Legacy - instance has this already - The install script requires the issue file to start with the string "Ubuntu"
# Legacy - default - sudo echo "Ubuntu Linux 20.04 LTS - Authorized uses only. All activity may be monitored and reported. \d \t @ \n" > /etc/issue

function run-until-success() {
  until $*
  do
    logger "Executing $* failed. Sleeping..."
    sleep 5
  done
}

# Install python 3.5 prerequisites
run-until-success sudo apt-get install --yes build-essential checkinstall
run-until-success sudo apt-get install --yes libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

# Install python 3.5.n source
cd /usr/src
run-until-success sudo wget https://www.python.org/ftp/python/3.5.9/Python-3.5.9.tgz
sudo tar xzf Python-3.5.9.tgz

# Build python
cd Python-3.5.9/
sudo ./configure --enable-optimizations
sudo make altinstall

# Retrieve and run awslogs install script
cd /
run-until-success sudo curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
sudo python3.5 ./awslogs-agent-setup.py -n -r ${var.aws-region} -c ./initial-awslogs.conf

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
  count      = min(1 - var.save-pp-data, var.enable-bastion)
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
  count = min(var.save-pp-data, var.enable-bastion)
  name  = "${var.aws-region-name}-${var.Env-Name}-backend-bastion-instance-policy"
  role  = aws_iam_role.bastion-instance-role[0].id
  depends_on = [
    aws_iam_role.bastion-instance-role,
    aws_s3_bucket.pp-data-bucket,
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
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::${var.Env-Name}-${lower(var.aws-region-name)}-pp-data/*"
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

