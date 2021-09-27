resource "aws_security_group" "elasticsearch_inbound" {
  name        = "elasticsearch-inbound"
  description = "Allow Outbound Traffic From the API"
  vpc_id      = var.vpc-id

  tags = {
    Name = "${title(var.Env-Name)} Elasticsearch inbound traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr-block]
  }
}

resource "aws_elasticsearch_domain" "govwifi_elasticsearch" {
  domain_name           = var.domain-name
  elasticsearch_version = "7.9"

  cluster_config {
    instance_type            = "t3.medium.elasticsearch"
    instance_count           = 1
    dedicated_master_enabled = false
    zone_awareness_enabled   = false
  }

  vpc_options {
    subnet_ids = [
      var.backend-subnet-id
    ]

    security_group_ids = [
      aws_security_group.elasticsearch_inbound.id,
    ]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }

  access_policies = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${var.aws-region}:${var.aws-account-id}:domain/${var.domain-name}/*"
    }
  ]
}
DOC
}
