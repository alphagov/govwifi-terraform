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
    echo "Executing $* failed. Sleeping..."
    sleep 5
  done
}

# Apt - Make sure everything is up to date
run-until-success apt-get update  --yes
run-until-success apt-get upgrade --yes

# We want to make sure that the journal does not write to syslog
# This would fill up the disk, with logs we already have in the journal
echo "Ensure journal does not write to syslog"
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
echo 'Installing and configuring chrony'
run-until-success apt-get install --yes chrony
sed '/pool/d' /etc/chrony/chrony.conf \
| cat <(echo "server 169.254.169.123 prefer iburst") - > /tmp/chrony.conf
echo "allow 127/8" >> /tmp/chrony.conf
mv /tmp/chrony.conf /etc/chrony/chrony.conf
systemctl restart chrony

# Install Docker and Send Logs to CloudWatch
echo 'Installing and configuring docker'
mkdir -p /etc/systemd/system/docker.service.d
run-until-success apt-get install --yes docker.io
cat <<EOF > /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --log-driver "local" 
# ExecStart=/usr/bin/dockerd --log-driver awslogs --log-opt awslogs-region=eu-west-2 --log-opt awslogs-group=${grafana_log_group} --dns 10.0.0.2
EOF

# Stop systemctl daemon to do some housekeeping (mount folders etc)
systemctl stop docker

# format drive if needed and mount to mount point
if [ "$(lsblk --noheadings --output FSTYPE ${grafana_device_name})" != "$drive_format" ]; then
  echo "Formatting blank drive ${grafana_device_name} to $drive_format"
  mkfs.$drive_format ${grafana_device_name};
  [ $? -ne 0 ] && echo "Failed to format drive";
fi

if [ ! -d $drive_mount_point ]; then
  echo "Making mount point '$drive_mount_point'";
  mkdir -p $drive_mount_point;
  [ $? -ne 0 ] && echo "Failed to make mount point";
fi

# write a line to /etc/fstab so the folder is mounted upon reboot
echo "${grafana_device_name}  $drive_mount_point $drive_format defaults  0 0" >> /etc/fstab
[ $? -ne 0 ] && echo "Failed write to fstab";

# go in here if the symlink_folder is not there as a symlink
if [ ! -L $symlink_folder ]; then
  # go in here if the symlink_folder IS there and is a normal folder
  if [ -d $symlink_folder ]; then
    # remove the old folder (may need to copy contents out if any file missing post install)
    rmdir $symlink_folder;
    [ $? -ne 0 ] && echo "Failed to remove $symlink_folder directory";
  fi
  # now its removed we need to symlink the volumes folder from the mounted EBS volume
  ln -s $docker_volumes_folder $symlink_folder;
  [ $? -ne 0 ] && echo "Failed to sym link $symlink_folder";
fi

# now mount the drive as set in /etc/fstab
mount $drive_mount_point;
[ $? -ne 0 ] && echo "Failed to mount drive";

# Reload and start docker
systemctl daemon-reload
systemctl enable --now docker

# If not already there create Docker volumes
[ -d $docker_volumes_folder/grafana-etc ] || docker volume create grafana-etc
[ -d $docker_volumes_folder/grafana ] || docker volume create grafana

# pull the Grafana Docker image 
docker pull grafana/grafana:${grafana_docker_version}

# run Grafana Docker image
docker run -id --restart=always -p 3000:3000 --name grafana --user root -v grafana:/var/lib/grafana -v grafana-etc:/etc/grafana \
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

echo 'Installing awscli'
run-until-success apt-get install --yes awscli

reboot
