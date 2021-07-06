#!/usr/bin/env bash

set -ueo pipefail

export DEBIAN_FRONTEND=noninteractive

# set some vars frequently used but not passed by terraformed to make script easy to change if needed
#File system format
drive_format="ext4"
#path for where docker keeps its volumes that we need to make persistent
docker_volumes_folder=/var/lib/docker/volumes
#folder where the EBS volume will be mounted
drive_mount_point=/mnt/grafana-persistent
#Symlink location that will be linked to the $docker_volumes_folder
symlink_folder=$drive_mount_point/volumes

function run-until-success() {
  until $*
  do
    logger -s "Executing $* failed. Sleeping..."
    sleep 5
  done
}

# Apt - Make sure everything is up to date
run-until-success apt-get update  --yes
run-until-success apt-get upgrade --yes

# We want to make sure that the journal does not write to syslog
# This would fill up the disk, with logs we already have in the journal
logger "Ensure journal does not write to syslog"
mkdir -p /etc/systemd/journald.conf.d/
cat <<JOURNAL > /etc/systemd/journald.conf.d/override.conf
[Journal]
SystemMaxUse=2G
RuntimeMaxUse=2G
ForwardToSyslog=no
ForwardToWall=no
JOURNAL

systemctl daemon-reload
systemctl restart systemd-journald

# Use Amazon NTP
# An implementation of Network Time Protocol (NTP). It can synchronise the system clock with NTP servers
logger 'Installing and configuring chrony'
run-until-success apt-get install --yes chrony
sed '/pool/d' /etc/chrony/chrony.conf \
| cat <(echo "server 169.254.169.123 prefer iburst") - > /tmp/chrony.conf
echo "allow 127/8" >> /tmp/chrony.conf
mv /tmp/chrony.conf /etc/chrony/chrony.conf
systemctl restart chrony

# Inject the CloudWatch Logs configuration file contents
sudo cat <<'EOF' > ./initial-awslogs.conf
[general]
state_file = /var/awslogs/state/agent-state

[/var/log/syslog]
file = /var/log/syslog
log_group_name = ${grafana-log-group}
log_stream_name = {instance_id}/var/log/syslog
datetime_format = %b %d %H:%M:%S

[/var/log/auth.log]
file = /var/log/auth.log
log_group_name = ${grafana-log-group}
log_stream_name = {instance_id}/var/log/auth.log
datetime_format = %b %d %H:%M:%S

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = ${grafana-log-group}
log_stream_name = {instance_id}/var/log/dmesg

[/var/log/unattended-upgrades/unattended-upgrades.log]
file = /var/log/unattended-upgrades/unattended-upgrades.log
log_group_name = ${grafana-log-group}
log_stream_name = {instance_id}/var/log/unattended-upgrades/unattended-upgrades.log
datetime_format = %Y-%m-%d %H:%M:%S

[/var/log/cloud-init-output.log]
file = /var/log/cloud-init-output.log
log_group_name = ${grafana-log-group}
log_stream_name = {instance_id}/var/log/cloud-init-output.log
EOF

# Install awslogs
# Steps required are install pre-reqs for python 3.5.n, install & build python 3.5 cos awslogs script only supports python < 3.5
# Legacy - instance has this already - The install script requires the issue file to start with the string "Ubuntu"
# Legacy - default - sudo echo "Ubuntu Linux 20.04 LTS - Authorized uses only. All activity may be monitored and reported. \d \t @ \n" > /etc/issue

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

# Legacy possibly - Try to circumvent pip install error with waiting for 10 seconds.
# sleep 10
sudo python3.5 ./awslogs-agent-setup.py -n -r eu-west-2 -c ./initial-awslogs.conf

# Install Docker and Send Logs to CloudWatch
logger 'Installing and configuring docker'
mkdir -p /etc/systemd/system/docker.service.d
run-until-success apt-get install --yes docker.io
cat <<EOF > /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --log-driver "local"
EOF

# Start and then stop systemctl daemon to do some housekeeping (mount folders etc)
logger "Starting docker";
run-until-success systemctl start docker
logger "Stopping docker";
run-until-success systemctl stop docker

# format drive if needed and mount to mount point
if [ "$(lsblk --noheadings --output FSTYPE ${grafana_device_name})" != "$drive_format" ]; then
  logger "Formatting blank drive ${grafana_device_name} to $drive_format"
  run-until-success mkfs.$drive_format ${grafana_device_name};
fi

if [ ! -d $drive_mount_point ]; then
  logger "Making mount point '$drive_mount_point'";
  run-until-success mkdir -p $drive_mount_point;
fi

# write a line to /etc/fstab so the folder is mounted upon reboot
logger "Writing mount line to /etc/fstab";
run-until-success echo "${grafana_device_name}  $drive_mount_point $drive_format defaults  0 0" >> /etc/fstab

# now mount the drive as set in /etc/fstab
logger "Mounting '$drive_mount_point'";
run-until-success mount $drive_mount_point;

if [ ! -d $symlink_folder ]; then
  logger "Moving docker volumes folder to persistent folder '$symlink_folder' as not currently present";
  run-until-success mv $docker_volumes_folder $symlink_folder;
fi

# go in here if the symlink_folder is not there as a symlink
if [ ! -L $docker_volumes_folder ]; then
  # go in here if the symlink_folder IS there and is a normal folder
  logger "'$docker_volumes_folder' does not exist as a symlink";
  if [ -d $docker_volumes_folder ]; then
    # remove the old folder (may need to copy contents out if any file missing post install)
    logger "'$docker_volumes_folder' does exist as a folder - removing";
    run-until-success rm -fr $docker_volumes_folder;
  fi
  # now its removed we need to symlink the volumes folder from the mounted EBS volume
  logger "Linking '$symlink_folder' to '$docker_volumes_folder'";
  run-until-success ln -s $symlink_folder $docker_volumes_folder;
fi

# Reload and start docker
logger "Reloading systemctl and enabling docker";
run-until-success systemctl daemon-reload
run-until-success systemctl enable --now docker

# If not already there create Docker volumes
if [ -d $docker_volumes_folder/grafana-etc ]; then
  logger "docker image for grafana-etc already present"
else
  logger "Creating docker image for grafana-etc"
  run-until-success docker volume create grafana-etc
fi

if [ -d $docker_volumes_folder/grafana ]; then
  logger "docker image for grafana already present"
else
  logger "Creating docker image for grafana"
  run-until-success docker volume create grafana
fi

# pull the Grafana Docker image 
logger "Pulling the grafana docker image for version ${grafana_docker_version}"
run-until-success docker pull grafana/grafana:${grafana_docker_version}

# run Grafana Docker image
logger "Starting docker for Grafana";
run-until-success docker run \
  --interactive \
  --detach \
  --restart=always \
  --publish=3000:3000 \
  --name=grafana \
  --user=root \
  --volume=grafana:/var/lib/grafana \
  --volume=grafana-etc:/etc/grafana \
  --env="GF_SERVER_ROOT_URL=${grafana_server_root_url}" \
  --env="GF_SERVER_HTTP_ADDR=0.0.0.0" \
  --env="GF_AUTH_BASIC_ENABLED=true" \
  --env="GF_SECURITY_ADMIN_USER=admin" \
  --env="GF_SECURITY_ADMIN_PASSWORD=${grafana_admin}" \
  --env="GF_SECURITY_COOKIE_SECURE=true" \
  --env="GF_SESSION_COOKIE_SECURE=true" \
  --env="GF_AUTH_GOOGLE_ENABLED=true" \
  --env="GF_AUTH_GOOGLE_ALLOW_SIGN_UP=true" \
  --env="GF_AUTH_GOOGLE_ALLOWED_DOMAINS=digital.cabinet-office.gov.uk" \
  --env="GF_AUTH_GOOGLE_AUTH_URL=https://accounts.google.com/o/oauth2/auth" \
  --env="GF_AUTH_GOOGLE_TOKEN_URL=https://accounts.google.com/o/oauth2/token" \
  --env="GF_AUTH_GOOGLE_CLIENT_SECRET=${google_client_secret}" \
  --env="GF_AUTH_GOOGLE_CLIENT_ID=${google_client_id}" \
  grafana/grafana:${grafana_docker_version}

logger 'Installing awscli with apt-get'
run-until-success apt-get install --yes awscli

reboot
