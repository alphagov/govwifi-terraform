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

# Install Docker and Send Logs to cloudwatch
echo 'Installing and configuring docker'
mkdir -p /etc/systemd/system/docker.service.d
run-until-success apt-get install --yes docker.io
cat <<EOF > /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --log-driver awslogs --log-opt awslogs-region=eu-west-2 --log-opt awslogs-group=${prometheus-log-group} --dns 10.0.0.2
EOF

# Reload systemctl daemon to pick up new override files
systemctl stop docker
systemctl daemon-reload
systemctl enable --now docker

# Install Prometheus
echo 'Installing prometheus'
run-until-success apt-get install --yes prometheus
service prometheus stop
chown prometheus:prometheus /srv/prometheus/metrics2
prometheus --storage.tsdb.path=/srv/prometheus/metrics2

## Install Prometheus Node exporter
echo 'Installing prometheus node exporter'
run-until-success apt-get install --yes prometheus-node-exporter
mkdir /etc/systemd/system/prometheus-node-exporter.service.d
# Create an environment file for prometheus node exporter
cat >  /etc/systemd/system/prometheus-node-exporter.service.d/prometheus-node-exporter.env <<EOF
ARGS="--collector.ntp --collector.diskstats.ignored-devices=^(ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$ --collector.filesystem.ignored-mount-points=^/(sys|proc|dev|run|var/lib/docker)($|/) --collector.netdev.ignored-devices=^lo$ --collector.textfile.directory=/var/lib/prometheus/node-exporter"
EOF
# Create an override file which will override prometheus node exporter service file
cat > /etc/systemd/system/prometheus-node-exporter.service.d/10-override-args.conf <<EOF
[Service]
EnvironmentFile=/etc/systemd/system/prometheus-node-exporter.service.d/prometheus-node-exporter.env
EOF
systemctl daemon-reload
systemctl enable prometheus-node-exporter
systemctl restart prometheus-node-exporter

## Configure Prometheus scrape points
## This overwrites the existing prometheus configuration
cat << EOF > /etc/prometheus/prometheus.yml
 ${prometheus_config}
EOF

## CREATE A VOLUME FOR PROMETHEUS INSTANCE DELETE AND ADD THIS TO TERRAFORM
echo 'Configuring prometheus EBS'
vol=""
while [ -z "$vol" ]; do
  # adapted from
  # https://medium.com/@moonape1226/mount-aws-ebs-on-ec2-automatically-with-cloud-init-e5e837e5438a
  # [Last accessed on 2020-04-02]
  vol=$(lsblk | grep -e disk | awk '{sub("G","",$4)} {if ($4+0 == ${data_volume_size}) print $1}')
  echo "still waiting for data volume ; sleeping 5"
  sleep 5
done
mkdir -p /srv/prometheus
echo "found volume /dev/$vol"
if [ -z "$(lsblk | grep "$vol" | awk '{print $7}')" ] ; then
  if [ -z "$(blkid /dev/$vol | grep ext4)" ] ; then
    echo "volume /dev/$vol is not formatted ; formatting"
    mkfs -F -t ext4 "/dev/$vol"
  else
    echo "volume /dev/$vol is already formatted"
  fi

  echo "volume /dev/$vol is not mounted ; mounting"
  mount "/dev/$vol" /srv/prometheus
  UUID=$(blkid /dev/$vol -s UUID -o value)
  if [ -z "$(grep $UUID /etc/fstab)" ] ; then
    echo "writing fstab entry"

    echo "UUID=$UUID /srv/prometheus ext4 defaults,nofail 0 2" >> /etc/fstab
  fi
fi

mkdir -p /srv/prometheus/metrics2
chown -R nobody /srv/prometheus

### END BLOCK TO DELETE








echo 'Installing awscli'
run-until-success apt-get install --yes awscli

#Initialise a node_creation_time metric to enable the predict_linear function to handle new nodes
echo "node_creation_time `date +%s`" > /var/lib/prometheus/node-exporter/node-creation-time.prom

cat <<EOF > /usr/bin/instance-reboot-required-metric.sh
#!/usr/bin/env bash

echo '# HELP node_reboot_required Node reboot is required for software updates.'
echo '# TYPE node_reboot_required gauge'
if [[ -f '/run/reboot-required' ]] ; then
  echo 'node_reboot_required 1'
else
  echo 'node_reboot_required 0'
fi
EOF

chmod +x /usr/bin/instance-reboot-required-metric.sh

run-until-success apt-get install --yes moreutils

crontab - <<EOF
$(crontab -l | grep -v 'no crontab')
*/5 * * * * /usr/bin/instance-reboot-required-metric.sh | sponge /var/lib/prometheus/node-exporter/reboot-required.prom
EOF

function run-until-success() {
  until $*
  do
    echo "Executing $* failed. Sleeping..."
    sleep 5
  done
}

reboot
