# The element() function used in subnets wraps around when the index is over the number of elements
# eg. in the 4th iteration the value returned will be the 1st, if there are only 3 elements in the list.
resource "aws_instance" "radius" {
  count                  = "${var.radius-instance-count}"
  ami                    = "${var.ami}"
  instance_type          = "t2.medium"
  key_name               = "${var.ssh-key-name}"
  subnet_id              = "${element(aws_subnet.wifi-frontend-subnet.*.id, count.index)}"
  vpc_security_group_ids = ["${var.radius-instance-sg-ids}"]
  iam_instance_profile   = "${aws_iam_instance_profile.ecs-instance-profile.id}"
  monitoring             = "${var.enable-detailed-monitoring}"

  user_data = <<DATA
Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-config; charset="us-ascii"
#cloud-config
repo_update: true
repo_upgrade: all

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set up daily security updates
# Make sure the updates are done in a staggered manner during the night
# as we are updating the ECS agent too which requires docker daemon restart

cat <<'EOF' > ./crontab
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed

42 * * * * root   run-parts /etc/cron.hourly
12 ${count.index + 1} * * * root   run-parts /etc/cron.daily

EOF

sudo cp ./crontab /etc/crontab

cat <<'EOF' > ./security-updates
#!/bin/bash
sudo yum update -y --security
sudo yum update -y ecs-init
sudo service docker restart
sleep 5
sudo start ecs
# Forcefully restart the instance if the docker daemon has failed to restart
# see https://github.com/docker/docker/issues/25382
docker ps || sudo reboot

EOF

chmod +x ./security-updates
sudo cp ./security-updates /etc/cron.daily

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set cluster name
echo ECS_CLUSTER=${var.Env-Name}-frontend-cluster >> /etc/ecs/ecs.config

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Install awslogs and the jq JSON parser
yum install -y awslogs jq

# Inject the CloudWatch Logs configuration file contents
cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = ${var.Env-Name}/var/log/dmesg
log_stream_name = {cluster}/{container_instance_id}

[/var/log/messages]
file = /var/log/messages
log_group_name = ${var.Env-Name}/var/log/messages
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/docker]
file = /var/log/docker
log_group_name = ${var.Env-Name}/var/log/docker
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%S.%f

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log.*
log_group_name = ${var.Env-Name}/var/log/ecs/ecs-init.log
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log.*
log_group_name = ${var.Env-Name}/var/log/ecs/ecs-agent.log
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log.*
log_group_name = ${var.Env-Name}/var/log/ecs/audit.log
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

EOF

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set the region to send CloudWatch Logs data to (the region where the container instance is located)
# region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
region=${var.aws-region}
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/upstart-job; charset="us-ascii"

#upstart-job
description "Configure and start CloudWatch Logs agent on Amazon ECS container instance"
author "Amazon Web Services"
start on started ecs

script
	exec 2>>/var/log/ecs/cloudwatch-logs-start.log
	set -x

	until curl -s http://localhost:51678/v1/metadata
	do
		sleep 1
	done

	# Grab the cluster and container instance ARN from instance metadata
	cluster=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .Cluster')
	container_instance_id=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $2}' )

	# Replace the cluster name and container instance ID placeholders with the actual values
	sed -i -e "s/{cluster}/$cluster/g" /etc/awslogs/awslogs.conf
	sed -i -e "s/{container_instance_id}/$container_instance_id/g" /etc/awslogs/awslogs.conf

	service awslogs start
	chkconfig awslogs on
end script
--==BOUNDARY==--
DATA

  tags {
    Name = "${title(var.Env-Name)} Frontend Radius-${var.dns-numbering-base + count.index + 1}"
    Env  = "${title(var.Env-Name)}"
  }
}

resource "aws_eip_association" "eip_assoc" {
  count       = "${var.radius-instance-count}"
  instance_id = "${element(aws_instance.radius.*.id, count.index)}"
  public_ip   = "${replace(element(var.elastic-ip-list, count.index), "/32", "")}"
}
