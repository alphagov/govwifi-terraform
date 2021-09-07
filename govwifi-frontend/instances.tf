# The element() function used in subnets wraps around when the index is over the number of elements
# eg. in the 4th iteration the value returned will be the 1st, if there are only 3 elements in the list.
resource "aws_instance" "radius" {
  count         = var.radius-instance-count
  ami           = var.ami
  instance_type = "t2.medium"
  key_name      = var.ssh-key-name
  subnet_id     = element(aws_subnet.wifi-frontend-subnet.*.id, count.index)

  vpc_security_group_ids = [
    aws_security_group.fe-ecs-out.id,
    aws_security_group.fe-admin-in.id,
    aws_security_group.fe-radius-out.id,
    aws_security_group.fe-radius-in.id,
    aws_security_group.fe-prometheus-in.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id
  monitoring           = var.enable-detailed-monitoring

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

yum install --assumeyes yum-cron

# The default is for all updates, switch to just security updates
sed -i 's/update_cmd = default/update_cmd = security/' /etc/yum/yum-cron.conf

# Actually apply updates, rather than just downloading them
sed -i 's/apply_updates = no/apply_updates = yes/' /etc/yum/yum-cron.conf

chkconfig yum-cron on

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set cluster name
echo ECS_CLUSTER=${aws_ecs_cluster.frontend-cluster.name} >> /etc/ecs/ecs.config

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash

yum install --assumeyes amazon-cloudwatch-agent awslogs

# Send CloudWatch Logs data to the region where the instance is located
sed -i -e "s/region = us-east-1/region = ${var.aws-region}/g" /etc/awslogs/awscli.conf

# Inject the CloudWatch Logs configuration file contents
cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = ${var.Env-Name}/var/log/dmesg
log_stream_name = ${aws_ecs_cluster.frontend-cluster.name}/{instance_id}

[/var/log/messages]
file = /var/log/messages
log_group_name = ${var.Env-Name}/var/log/messages
log_stream_name = ${aws_ecs_cluster.frontend-cluster.name}/{instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log
log_group_name = ${var.Env-Name}/var/log/ecs/ecs-init.log
log_stream_name = ${aws_ecs_cluster.frontend-cluster.name}/{instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log
log_group_name = ${var.Env-Name}/var/log/ecs/ecs-agent.log
log_stream_name = ${aws_ecs_cluster.frontend-cluster.name}/{instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log
log_group_name = ${var.Env-Name}/var/log/ecs/audit.log
log_stream_name = ${aws_ecs_cluster.frontend-cluster.name}/{instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

EOF

systemctl enable awslogsd.service
systemctl start awslogsd.service

--==BOUNDARY==

DATA


  tags = {
    Name = "${title(var.Env-Name)} Frontend Radius-${var.dns-numbering-base + count.index + 1}"
    Env  = title(var.Env-Name)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip_association" "eip_assoc" {
  count       = var.radius-instance-count
  instance_id = element(aws_instance.radius.*.id, count.index)
  public_ip   = replace(element(var.elastic-ip-list, count.index), "/32", "")
}

