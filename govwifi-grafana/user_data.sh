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

# Install Docker and Send Logs to CloudWatch
logger 'Installing and configuring docker'
mkdir -p /etc/systemd/system/docker.service.d
run-until-success apt-get install --yes docker.io
cat <<EOF > /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --log-driver "local" 
# ExecStart=/usr/bin/dockerd --log-driver awslogs --log-opt awslogs-region=eu-west-2 --log-opt awslogs-group=${grafana_log_group} --dns 10.0.0.2
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

# go in here if the symlink_folder is not there as a symlink
if [ ! -L $docker_volumes_folder ]; then
  # go in here if the symlink_folder IS there and is a normal folder
  logger "'$docker_volumes_folder' does not exist as a symlink";
  if [ -d $docker_volumes_folder ]; then
    # remove the old folder (may need to copy contents out if any file missing post install)
    logger "'$docker_volumes_folder' does exist as a folder";
    run-until-success rmdir $docker_volumes_folder;
  fi
  # now its removed we need to symlink the volumes folder from the mounted EBS volume
  logger "Linking '$symlink_folder' to '$docker_volumes_folder'";
  run-until-success ln -s $symlink_folder $docker_volumes_folder;
fi

# now mount the drive as set in /etc/fstab
logger "Mounting '$drive_mount_point'";
run-until-success mount $drive_mount_point;

if [ ! -d $symlink_folder ]; then
  logger "Making persistent folder '$symlink_folder' as not currently created";
  run-until-success mkdir -p $symlink_folder;
fi

# Reload and start docker
logger "Reloading systemctl and enabling docker";
run-until-success systemctl daemon-reload
run-until-success systemctl enable --now docker

# If not already there create Docker volumes
if [ -d $docker_volumes_folder/grafana-etc ]; then
  logger "Creating docker image for grafana-etc"
  run-until-success docker volume create grafana-etc
else
  logger "docker image for grafana-etc already present"
fi

if [ -d $docker_volumes_folder/grafana ]; then
  logger "Creating docker image for grafana"
  run-until-success docker volume create grafana
else
  logger "docker image for grafana already present"
fi

# pull the Grafana Docker image 
logger "Pulling the grafana docker image for version ${grafana_docker_version}"
run-until-success docker pull grafana/grafana:${grafana_docker_version}

# run Grafana Docker image
run-until-success docker run -id --restart=always -p 3000:3000 --name grafana --user root -v grafana:/var/lib/grafana -v grafana-etc:/etc/grafana \
-e "GF_SECURITY_ADMIN_PASSWORD=${grafana_admin}" \
-e "GF_SERVER_ROOT_URL=${grafana_server_root_url}" \
-e "GF_AUTH_BASIC_ENABLED=true" \
-e "GF_AUTH_GOOGLE_ENABLED=true" \
-e "GF_AUTH_GOOGLE_ALLOW_SIGN_UP=false" \
-e "GF_SECURITY_COOKIE_SECURE=true" \
-e "GF_SESSION_COOKIE_SECURE=true" \
-e "GF_SERVER_HTTP_ADDR=0.0.0.0" \
-e "GF_AUTH_GOOGLE_AUTH_URL=https://accounts.google.com/o/oauth2/auth" \
-e "GF_AUTH_GOOGLE_TOKEN_URL=https://accounts.google.com/o/oauth2/token" \
-e "GF_AUTH_GOOGLE_CLIENT_SECRET=${google_client_secret}" \
-e "GF_AUTH_GOOGLE_CLIENT_ID=${google_client_id}" \
-e "GF_AUTH_GOOGLE_ALLOWED_DOMAINS=digital.cabinet-office.gov.uk" \
grafana/grafana:${grafana_docker_version}

logger 'Installing awscli with apt-get'
run-until-success apt-get install --yes awscli

reboot
