#!/usr/bin/env bash
set -ueo pipefail

export DEBIAN_FRONTEND=noninteractive

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
# ExecStart=/usr/bin/dockerd --log-driver awslogs --log-opt awslogs-region=eu-west-2 --log-opt awslogs-group=${grafana-log-group} --dns 10.0.0.2
EOF

# Reload systemctl daemon to pick up new override files
systemctl stop docker
systemctl daemon-reload
systemctl enable --now docker

# Create Docker volumes and run Grafana Docker image
docker volume create grafana-etc
docker volume create grafana
docker pull grafana/grafana:7.4.0
docker run -id --restart=always -p 3000:3000 --name grafana --user root -v grafana:/var/lib/grafana -v grafana-etc:/etc/grafana \
-e "GF_SECURITY_ADMIN_PASSWORD=${grafana-admin}" \
-e "GF_SERVER_ROOT_URL=${grafana-server-root-url}" \
-e "GF_AUTH_BASIC_ENABLED=true" \
-e "GF_AUTH_GOOGLE_ENABLED=true" \
-e "GF_AUTH_GOOGLE_ALLOW_SIGN_UP=true" \
-e "GF_SECURITY_COOKIE_SECURE=true" \
-e "GF_SESSION_COOKIE_SECURE=true" \
-e "GF_SERVER_HTTP_ADDR=0.0.0.0" \
-e "GF_AUTH_GOOGLE_AUTH_URL=https://accounts.google.com/o/oauth2/auth" \
-e "GF_AUTH_GOOGLE_TOKEN_URL=https://accounts.google.com/o/oauth2/token" \
-e "GF_AUTH_GOOGLE_CLIENT_SECRET=${google-client-secret}" \
-e "GF_AUTH_GOOGLE_CLIENT_ID=${google-client-id}" \
-e "GF_ALLOWED_DOMAINS=digital.cabinet-office.gov.uk" \
grafana/grafana:7.4.0

echo 'Installing awscli'
run-until-success apt-get install --yes awscli


reboot
