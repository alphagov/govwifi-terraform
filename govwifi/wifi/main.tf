module "tfstate" {
  providers = {
    aws = aws.AWS-main
  }

  source             = "../../terraform-state"
  product-name       = var.product-name
  Env-Name           = var.Env-Name
  aws-account-id     = local.aws_account_id
  aws-region         = var.aws-region
  aws-region-name    = var.aws-region-name
  backup-region-name = var.backup-region-name

  # TODO: separate module for accesslogs
  accesslogs-glacier-transition-days = 30
  accesslogs-expiration-days         = 90
}

terraform {
  backend "s3" {
    # Interpolation is not allowed here.
    #bucket = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate"
    #key    = "${lower(var.aws-region-name)}-tfstate"
    #region = "${var.aws-region}"
    bucket = "govwifi-wifi-dublin-tfstate"

    key    = "dublin-tfstate"
    region = "eu-west-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "2.10.0"
    }
  }
}

provider "aws" {
  alias  = "AWS-main"
  region = var.aws-region
}

provider "aws" {
  alias  = "route53-alarms"
  region = "us-east-1"
}

module "govwifi_keys" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../govwifi-keys"

  create_production_bastion_key = 1
  is_production_aws_account     = var.is_production_aws_account

  govwifi-bastion-key-name = "govwifi-bastion-key-20210630"
  govwifi-bastion-key-pub  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDY/Q676Tp5CTpKWVksMPztERDdjWOrYFgVckF9IHGI2wC38ckWFiqawsEZBILUyNZgL/lnOtheN1UZtuGmUUkPxgtPw+YD6gMDcebhSX4wh9GM3JjXAIy9+V/WagQ84Pz10yIp+PlyzcQMu+RVRVzWyTYZUdgMsDt0tFdcgMgUc7FkC252CgtSZHpLXhnukG5KG69CoTO+kuak/k3vX5jwWjIgfMGZwIAq+F9XSIMAwylCmmdE5MetKl0Wx4EI/fm8WqSZXj+yeFRv9mQTus906AnNieOgOrgt4D24/JuRU1JTlZ35iNbOKcwlOTDSlTQrm4FA1sCllphhD/RQVYpMp6EV3xape626xwkucCC2gYnakxTZFHUIeWfC5aHGrqMOMtXRfW0xs+D+vzo3MCWepdIebWR5KVhqkbNUKHBG9e8oJbTYUkoyBZjC7LtI4fgB3+blXyFVuQoAzjf+poPzdPBfCC9eiUJrEHoOljO9yMcdkBfyW3c/o8Sd9PgNufc= bastion@govwifi"

  govwifi-key-name     = var.ssh-key-name
  govwifi-key-name-pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJmLa/tF941z6Dh/jiZCH6Mw/JoTXGkILim/bgDc3PSBKXFmBwkAFUVgnoOUWJDXvZWpuBJv+vUu+ZlmlszFM00BRXpb4ykRuJxWIjJiNzGlgXW69Satl2e9d37ZtLwlAdABgJyvj10QEiBtB1VS0DBRXK9J+CfwNPnwVnfppFGP86GoqE2Il86t+BB/VC//gKMTttIstyl2nqUwkK3Epq66+1ol3AelmUmBjPiyrmkwp+png9F4B86RqSNa/drfXmUGf1czE4+H+CXqOdje2bmnrwxLQ8GY3MYpz0zTVrB3T1IyXXF6dcdcF6ZId9B/10jMiTigvOeUvraFEf9fK7 govwifi@govwifi"

}

# Backend =====================================================================
module "backend" {
  providers = {
    aws = aws.AWS-main
  }

  source                    = "../../govwifi-backend"
  env                       = "production"
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account


  # AWS VPC setup -----------------------------------------
  aws-region      = var.aws-region
  aws-region-name = var.aws-region-name
  route53-zone-id = local.route53_zone_id
  vpc-cidr-block  = "10.42.0.0/16"
  zone-count      = var.zone-count
  zone-names      = var.zone-names

  zone-subnets = {
    zone0 = "10.42.1.0/24"
    zone1 = "10.42.2.0/24"
    zone2 = "10.42.3.0/24"
  }

  administrator_ips   = var.administrator_ips
  frontend-radius-IPs = local.frontend_radius_ips

  # Instance-specific setup -------------------------------
  # eu-west-1, CIS Ubuntu Linux 16.04 LTS Benchmark v1.0.0.4 - Level 1
  # bastion-ami = "ami-51d3e928"
  # eu-west-2 eu-west-2, CIS Ubuntu Linux 20.04 LTS
  bastion-ami               = "ami-08bac620dc84221eb"
  bastion-instance-type     = "t2.micro"
  bastion-server-ip         = var.bastion_server_ip
  bastion-ssh-key-name      = "govwifi-bastion-key-20210630"
  enable-bastion-monitoring = true
  users                     = var.users
  aws-account-id            = local.aws_account_id

  db-instance-count        = 0
  session-db-instance-type = "db.m4.xlarge"
  session-db-storage-gb    = 1000
  db-backup-retention-days = 7
  db-encrypt-at-rest       = true
  db-maintenance-window    = "wed:01:42-wed:02:12"
  db-backup-window         = "04:42-05:42"

  db-replica-count      = 0
  user-db-replica-count = 1
  rr-instance-type      = "db.m3.medium"
  rr-storage-gb         = 1000

  critical-notifications-arn = module.critical-notifications.topic-arn
  capacity-notifications-arn = module.capacity-notifications.topic-arn
  user-replica-source-db     = "arn:aws:rds:eu-west-2:${local.aws_account_id}:db:wifi-production-user-db"

  # Seconds. Set to zero to disable monitoring
  db-monitoring-interval = 60

  # Passed to application
  user-db-instance-type = "db.t2.medium"
  user-db-hostname      = var.user-db-hostname
  user-db-storage-gb    = 20
  user-rr-hostname      = var.user-rr-hostname
  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland
  grafana_ip            = var.grafana_ip

  use_env_prefix = var.use_env_prefix

  db-storage-alarm-threshold = 32212254720
}

# Emails ======================================================================
module "emails" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../govwifi-emails"

  is_production_aws_account = var.is_production_aws_account
  product-name              = var.product-name
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  aws-account-id            = local.aws_account_id
  route53-zone-id           = local.route53_zone_id
  aws-region                = var.aws-region
  aws-region-name           = var.aws-region-name
  mail-exchange-server      = "10 inbound-smtp.eu-west-1.amazonaws.com"
  devops-notifications-arn  = module.devops-notifications.topic-arn

  #sns-endpoint             = "https://elb.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk/sns/"
  sns-endpoint                       = "https://elb.london.${var.Env-Subdomain}.service.gov.uk/sns/"
  user-signup-notifications-endpoint = "https://user-signup-api.${var.Env-Subdomain}.service.gov.uk:8443/user-signup/email-notification"
}

# Global ====================================================================
#moved for wifi-london
#module "govwifi_account" {
#  providers = {
#    "aws" = "aws.AWS-main"
#  }
#
#  source     = "../../govwifi-account"
#  account-id = "${var.aws-parent-account-id}"
#}

module "dns" {
  providers = {
    aws = aws.AWS-main
  }

  source             = "../../global-dns"
  Env-Subdomain      = var.Env-Subdomain
  route53-zone-id    = local.route53_zone_id
  status-page-domain = "bl6klm1cjshh.stspg-customer.com"
}

# Frontend ====================================================================
module "frontend" {
  providers = {
    aws                = aws.AWS-main
    aws.route53-alarms = aws.route53-alarms
  }

  source                    = "../../govwifi-frontend"
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account


  # AWS VPC setup -----------------------------------------
  aws-region         = var.aws-region
  aws-region-name    = var.aws-region-name
  route53-zone-id    = local.route53_zone_id
  vpc-cidr-block     = "10.43.0.0/16"
  zone-count         = var.zone-count
  zone-names         = var.zone-names
  rack-env           = "production"
  sentry-current-env = "production"


  zone-subnets = {
    zone0 = "10.43.1.0/24"
    zone1 = "10.43.2.0/24"
    zone2 = "10.43.3.0/24"
  }

  # Instance-specific setup -------------------------------
  radius-instance-count      = 3
  enable-detailed-monitoring = true

  # eg. dns records are generated for radius(N).x.service.gov.uk
  # where N = this base + 1 + server#
  dns-numbering-base = 0

  elastic-ip-list       = local.frontend_region_ips
  ami                   = var.ami
  ssh-key-name          = var.ssh-key-name
  frontend-docker-image = format("%s/frontend:production", local.docker_image_path)
  raddb-docker-image    = format("%s/raddb:production", local.docker_image_path)

  # admin bucket
  admin-bucket-name = "govwifi-production-admin"

  logging-api-base-url = var.london-api-base-url
  auth-api-base-url    = var.dublin-api-base-url

  route53-critical-notifications-arn = module.route53-critical-notifications.topic-arn
  devops-notifications-arn           = module.devops-notifications.topic-arn

  bastion_server_ip = var.bastion_server_ip

  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland

  radius-CIDR-blocks = [for ip in local.frontend_radius_ips : "${ip}/32"]

  use_env_prefix = var.use_env_prefix
}

module "api" {
  providers = {
    aws = aws.AWS-main
  }

  env                       = "production"
  source                    = "../../govwifi-api"
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  backend-elb-count       = 1
  backend-instance-count  = 2
  authorisation-api-count = 3
  aws-account-id          = local.aws_account_id
  aws-region-name         = lower(var.aws-region-name)
  aws-region              = var.aws-region
  route53-zone-id         = local.route53_zone_id
  vpc-id                  = module.backend.backend-vpc-id

  user-signup-enabled  = 0
  logging-enabled      = 0
  alarm-count          = 0
  safe-restart-enabled = 0
  event-rule-count     = 0

  devops-notifications-arn = module.devops-notifications.topic-arn
  notification_arn         = module.region_pagerduty.topic_arn

  auth-docker-image             = format("%s/authorisation-api:production", local.docker_image_path)
  logging-docker-image          = format("%s/logging-api:production", local.docker_image_path)
  safe-restart-docker-image     = format("%s/safe-restarter:production", local.docker_image_path)
  backup-rds-to-s3-docker-image = ""

  db-hostname               = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  rack-env                  = "production"
  sentry-current-env        = "production"
  radius-server-ips         = local.frontend_radius_ips
  authentication_sentry_dsn = var.auth_sentry_dsn
  safe_restart_sentry_dsn   = var.safe_restart_sentry_dsn
  user-signup-docker-image  = ""
  logging_sentry_dsn        = ""
  user_signup_sentry_dsn    = ""
  subnet-ids                = module.backend.backend-subnet-ids
  user-db-hostname          = var.user-db-hostname
  user-rr-hostname          = var.user-rr-hostname

  backend-sg-list = [
    module.backend.be-admin-in,
  ]

  use_env_prefix = var.use_env_prefix

  low_cpu_threshold = 1
}

module "critical-notifications" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../sns-notification"

  topic-name = "govwifi-wifi-critical"
  emails     = [var.critical_notification_email]
}

module "capacity-notifications" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../sns-notification"

  topic-name = "govwifi-wifi-capacity"
  emails     = [var.capacity_notification_email]
}

module "devops-notifications" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../sns-notification"

  topic-name = "govwifi-wifi-devops"
  emails     = [var.devops_notification_email]
}

module "route53-critical-notifications" {
  providers = {
    aws = aws.route53-alarms
  }

  source = "../../sns-notification"

  topic-name = "govwifi-wifi-critical"
  emails     = [var.critical_notification_email]
}

module "region_pagerduty" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../govwifi-pagerduty-integration"

  sns_topic_subscription_https_endpoint = local.pagerduty_https_endpoint
}

# This is used for the alarms connected to the Route 53 healthchecks
# in this region
module "us_east_1_pagerduty" {
  providers = {
    aws = aws.route53-alarms
  }

  source = "../../govwifi-pagerduty-integration"

  sns_topic_subscription_https_endpoint = local.pagerduty_https_endpoint
}

module "govwifi_prometheus" {
  providers = {
    aws = aws.AWS-main
  }

  source     = "../../govwifi-prometheus"
  Env-Name   = var.Env-Name
  aws-region = var.aws-region

  ssh-key-name = var.ssh-key-name

  frontend-vpc-id = module.frontend.frontend-vpc-id

  fe-admin-in   = module.frontend.fe-admin-in
  fe-ecs-out    = module.frontend.fe-ecs-out
  fe-radius-in  = module.frontend.fe-radius-in
  fe-radius-out = module.frontend.fe-radius-out

  wifi-frontend-subnet       = module.frontend.wifi-frontend-subnet
  london_radius_ip_addresses = var.london_radius_ip_addresses
  dublin_radius_ip_addresses = var.dublin_radius_ip_addresses

  # Feature toggle creating Prometheus server.
  create_prometheus_server = 1

  prometheus_ip = var.prometheus_ip_ireland
  grafana_ip    = var.grafana_ip
}
