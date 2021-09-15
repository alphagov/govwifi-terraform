# The element() function used in subnets wraps around when the index is over the number of elements
# eg. in the 4th iteration the value returned will be the 1st, if there are only 3 elements in the list.
resource "aws_instance" "radius" {
  count         = var.radius-instance-count
  ami           = var.ami
  instance_type = "t2.medium"
  key_name      = var.ssh-key-name
  subnet_id     = element(aws_subnet.wifi_frontend_subnet.*.id, count.index)

  vpc_security_group_ids = [
    aws_security_group.fe_ecs_out.id,
    aws_security_group.fe_admin_in.id,
    aws_security_group.fe_radius_out.id,
    aws_security_group.fe_radius_in.id,
    aws_security_group.fe_prometheus_in.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.id
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
echo ECS_CLUSTER=${aws_ecs_cluster.frontend_cluster.name} >> /etc/ecs/ecs.config

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash

yum install --assumeyes amazon-cloudwatch-agent

# Inject the CloudWatch Logs configuration file contents
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << EOF
{
  "agent": {
    "metrics_collection_interval": 60
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/dmesg",
            "log_group_name": "staging/var/log/dmesg",
            "log_stream_name": "staging-frontend-cluster/{instance_id}"
          },
          {
            "file_path": "/var/log/ecs/audit.log",
            "log_group_name": "staging/var/log/ecs/audit.log",
            "log_stream_name": "staging-frontend-cluster/{instance_id}",
            "timestamp_format": "%Y-%m-%dT%H:%M:%SZ"
          },
          {
            "file_path": "/var/log/ecs/ecs-agent.log",
            "log_group_name": "staging/var/log/ecs/ecs-agent.log",
            "log_stream_name": "staging-frontend-cluster/{instance_id}",
            "timestamp_format": "%Y-%m-%dT%H:%M:%SZ"
          },
          {
            "file_path": "/var/log/ecs/ecs-init.log",
            "log_group_name": "staging/var/log/ecs/ecs-init.log",
            "log_stream_name": "staging-frontend-cluster/{instance_id}",
            "timestamp_format": "%Y-%m-%dT%H:%M:%SZ"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "staging/var/log/messages",
            "log_stream_name": "staging-frontend-cluster/{instance_id}",
            "timestamp_format": "%b %d %H:%M:%S"
          }
        ]
      }
    }
  },
  "metrics": {
    "append_dimensions": {
      "AutoScalingGroupName": "\$${aws:AutoScalingGroupName}",
      "ImageId": "\$${aws:ImageId}",
      "InstanceId": "\$${aws:InstanceId}",
      "InstanceType": "\$${aws:InstanceType}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 60,
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          "used_percent",
          "inodes_free"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "*"
        ]
      },
      "diskio": {
        "measurement": [
          "io_time"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      },
      "swap": {
        "measurement": [
          "swap_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    }
  }
}
EOF

systemctl enable amazon-cloudwatch-agent.service
systemctl start amazon-cloudwatch-agent.service

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
