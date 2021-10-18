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
  required_version = "~> 0.15.5"

  backend "s3" {
    # Interpolation is not allowed here.
    #bucket = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate"
    #key    = "${lower(var.aws-region-name)}-tfstate"
    #region = "${var.aws-region}"
    bucket = "govwifi-wifi-london-tfstate"

    key    = "london-tfstate"
    region = "eu-west-2"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias  = "AWS-main"
  region = var.aws-region
}

provider "aws" {
  alias  = "us_east_1"
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

# Global ====================================================================

module "govwifi_account" {
  providers = {
    aws = aws.AWS-main
  }

  source         = "../../govwifi-account"
  aws-account-id = local.aws_account_id
}

# ====================================================================

module "backend" {
  providers = {
    aws = aws.AWS-main
    # Instance-specific setup -------------------------------
  }

  source                    = "../../govwifi-backend"
  env                       = "production"
  env_name                  = var.Env-Name
  env_subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account


  # AWS VPC setup -----------------------------------------
  aws_region      = var.aws-region
  aws_region_name = var.aws-region-name
  route53_zone_id = local.route53_zone_id
  vpc_cidr_block  = "10.84.0.0/16"
  zone_count      = var.zone-count
  zone_names      = var.zone-names

  zone_subnets = {
    zone0 = "10.84.1.0/24"
    zone1 = "10.84.2.0/24"
    zone2 = "10.84.3.0/24"
  }

  administrator_ips   = var.administrator_ips
  frontend_radius_ips = local.frontend_radius_ips

  # eu-west-2, CIS Ubuntu Linux 16.04 LTS Benchmark v1.0.0.4 - Level 1
  #bastion-ami                = "ami-ae6d81c9"
  # eu-west-2, CIS Ubuntu Linux 20.04 LTS
  bastion_ami                = "ami-096cb92bb3580c759"
  bastion_instance_type      = "t2.micro"
  bastion_server_ip          = var.bastion_server_ip
  bastion_ssh_key_name       = "govwifi-bastion-key-20210630"
  enable_bastion_monitoring  = true
  users                      = var.users
  aws_account_id             = local.aws_account_id
  db_instance_count          = 1
  session_db_instance_type   = "db.m4.xlarge"
  session_db_storage_gb      = 1000
  db_backup_retention_days   = 7
  db_encrypt_at_rest         = true
  db_maintenance_window      = "wed:01:42-wed:02:12"
  db_backup_window           = "03:05-04:05"
  db_replica_count           = 1
  rr_instance_type           = "db.m4.xlarge"
  rr_storage_gb              = 1000
  critical_notifications_arn = module.critical-notifications.topic-arn
  capacity_notifications_arn = module.capacity-notifications.topic-arn
  user_replica_source_db     = "wifi-production-user-db"

  # Seconds. Set to zero to disable monitoring
  db_monitoring_interval = 60

  # Passed to application
  user_db_hostname      = var.user-db-hostname
  user_rr_hostname      = var.user-rr-hostname
  user_db_instance_type = "db.t2.medium"
  user_db_storage_gb    = 1000
  user_db_replica_count = 1

  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland
  grafana_ip            = var.grafana_ip

  use_env_prefix   = var.use_env_prefix
  backup_mysql_rds = var.backup_mysql_rds

  db_storage_alarm_threshold = 32212254720
}

# London Frontend ======DIFFERENT AWS REGION===================================
module "frontend" {
  providers = {
    aws           = aws.AWS-main
    aws.us_east_1 = aws.us_east_1
  }

  source                    = "../../govwifi-frontend"
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  # AWS VPC setup -----------------------------------------
  # LONDON
  aws-region = var.aws-region

  aws-region-name    = var.aws-region-name
  route53-zone-id    = local.route53_zone_id
  vpc-cidr-block     = "10.85.0.0/16"
  zone-count         = var.zone-count
  zone-names         = var.zone-names
  rack-env           = "production"
  sentry-current-env = "production"

  zone-subnets = {
    zone0 = "10.85.1.0/24"
    zone1 = "10.85.2.0/24"
    zone2 = "10.85.3.0/24"
  }

  # Instance-specific setup -------------------------------
  radius-instance-count      = 3
  enable-detailed-monitoring = true

  # eg. dns records are generated for radius(N).x.service.gov.uk
  # where N = this base + 1 + server#
  dns-numbering-base = 3

  elastic-ip-list       = local.frontend_region_ips
  ami                   = var.ami
  ssh-key-name          = var.ssh-key-name
  frontend-docker-image = format("%s/frontend:production", local.docker_image_path)
  raddb-docker-image    = format("%s/raddb:production", local.docker_image_path)

  # admin bucket
  admin-bucket-name = "govwifi-production-admin"

  logging-api-base-url = var.london-api-base-url
  auth-api-base-url    = var.london-api-base-url

  critical_notifications_arn           = module.critical-notifications.topic-arn
  us_east_1_critical_notifications_arn = module.route53-critical-notifications.topic-arn

  bastion_server_ip = var.bastion_server_ip

  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland

  radius-CIDR-blocks = [for ip in local.frontend_radius_ips : "${ip}/32"]

  use_env_prefix = var.use_env_prefix
}

module "govwifi_admin" {
  providers = {
    aws = aws.AWS-main
  }

  source                    = "../../govwifi-admin"
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  aws-region      = var.aws-region
  aws-region-name = var.aws-region-name
  vpc-id          = module.backend.backend-vpc-id
  instance-count  = 2

  admin-docker-image = format("%s/admin:production", local.docker_image_path)
  rack-env           = "production"
  sentry-current-env = "production"

  subnet-ids = module.backend.backend-subnet-ids

  db-instance-type         = "db.t2.large"
  db-storage-gb            = 120
  db-backup-retention-days = 1
  db-encrypt-at-rest       = true
  db-maintenance-window    = "sat:00:42-sat:01:12"
  db-backup-window         = "03:42-04:42"
  db-monitoring-interval   = 60

  rr-db-host = "rr.london.wifi.service.gov.uk"
  rr-db-name = "govwifi_wifi"

  user-db-host = var.user-rr-hostname
  user-db-name = "govwifi_production_users"

  critical-notifications-arn = module.critical-notifications.topic-arn
  capacity-notifications-arn = module.capacity-notifications.topic-arn
  notification_arn           = module.region_pagerduty.topic_arn

  rds-monitoring-role = module.backend.rds-monitoring-role

  london_radius_ip_addresses = var.london_radius_ip_addresses
  dublin_radius_ip_addresses = var.dublin_radius_ip_addresses
  sentry-dsn                 = var.admin_sentry_dsn
  public-google-api-key      = var.public-google-api-key

  logging-api-search-url = "https://api-elb.london.${var.Env-Subdomain}.service.gov.uk:8443/logging/authentication/events/search/"

  zendesk-api-endpoint = "https://govuk.zendesk.com/api/v2/"
  zendesk_api_user     = var.zendesk_api_user

  bastion_server_ip = var.bastion_server_ip

  use_env_prefix = false
}

module "api" {
  providers = {
    aws = aws.AWS-main
  }

  source                    = "../../govwifi-api"
  env                       = "production"
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  backend-elb-count      = 1
  backend-instance-count = 3
  aws-account-id         = local.aws_account_id
  aws-region-name        = var.aws-region-name
  aws-region             = var.aws-region
  route53-zone-id        = local.route53_zone_id
  vpc-id                 = module.backend.backend-vpc-id

  devops-notifications-arn = module.devops-notifications.topic-arn
  notification_arn         = module.region_pagerduty.topic_arn

  auth-docker-image             = format("%s/authorisation-api:production", local.docker_image_path)
  user-signup-docker-image      = format("%s/user-signup-api:production", local.docker_image_path)
  logging-docker-image          = format("%s/logging-api:production", local.docker_image_path)
  safe-restart-docker-image     = format("%s/safe-restarter:production", local.docker_image_path)
  backup-rds-to-s3-docker-image = format("%s/database-backup:production", local.docker_image_path)

  db-hostname               = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"
  rack-env                  = "production"
  sentry-current-env        = "production"
  radius-server-ips         = local.frontend_radius_ips
  authentication_sentry_dsn = var.auth_sentry_dsn
  safe_restart_sentry_dsn   = var.safe_restart_sentry_dsn
  user_signup_sentry_dsn    = var.user_signup_sentry_dsn
  logging_sentry_dsn        = var.logging_sentry_dsn
  subnet-ids                = module.backend.backend-subnet-ids
  user-db-hostname          = var.user-db-hostname
  user-rr-hostname          = var.user-rr-hostname
  admin-bucket-name         = "govwifi-production-admin"
  user-signup-api-is-public = 1

  backend-sg-list = [
    module.backend.be-admin-in,
  ]

  metrics-bucket-name = module.govwifi_dashboard.metrics-bucket-name

  use_env_prefix          = var.use_env_prefix
  backup_mysql_rds        = var.backup_mysql_rds
  rds_mysql_backup_bucket = module.backend.rds_mysql_backup_bucket

  low_cpu_threshold = 10
}

module "critical-notifications" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../sns-notification"

  topic_name = "govwifi-wifi-critical"
  emails     = [var.critical_notification_email]
}

module "capacity-notifications" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../sns-notification"

  topic_name = "govwifi-wifi-capacity"
  emails     = [var.capacity_notification_email]
}

module "devops-notifications" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../sns-notification"

  topic_name = "govwifi-wifi-devops"
  emails     = [var.devops_notification_email]
}

module "route53-critical-notifications" {
  providers = {
    aws = aws.us_east_1
  }

  source = "../../sns-notification"

  topic_name = "govwifi-wifi-critical-london"
  emails     = [var.critical_notification_email]
}

locals {
  pagerduty_https_endpoint = jsondecode(data.aws_secretsmanager_secret_version.pagerduty_config.secret_string)["integration-url"]
}

module "region_pagerduty" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../govwifi-pagerduty-integration"

  sns_topic_subscription_https_endpoint = local.pagerduty_https_endpoint
}

module "govwifi_dashboard" {
  providers = {
    aws = aws.AWS-main
  }

  source   = "../../govwifi-dashboard"
  Env-Name = var.Env-Name
}

/*
We are only configuring a Prometheus server in London for now.
The server will scrape metrics from the agents configured in both regions.
The module `govwifi-prometheus` only needs to exist in
govwifi/staging-london/main.tf and govwifi/wifi-london/main.tf.
*/
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
  # Value defaults to 0 and should only be enabled (i.e., value = 1) in staging-london and wifi-london
  create_prometheus_server = 1

  prometheus_ip = var.prometheus_ip_london
  grafana_ip    = var.grafana_ip
}

module "govwifi_grafana" {
  providers = {
    aws = aws.AWS-main
  }

  source                     = "../../govwifi-grafana"
  Env-Name                   = var.Env-Name
  Env-Subdomain              = var.Env-Subdomain
  aws-region                 = var.aws-region
  critical-notifications-arn = module.critical-notifications.topic-arn
  is_production_aws_account  = var.is_production_aws_account

  ssh-key-name = var.ssh-key-name

  subnet-ids = module.backend.backend-subnet-ids

  backend-subnet-ids = module.backend.backend-subnet-ids

  be-admin-in = module.backend.be-admin-in

  # Feature toggle so we only create the Grafana instance in Staging London
  create_grafana_server = "1"

  vpc-id = module.backend.backend-vpc-id

  bastion_ip = var.bastion_server_ip

  administrator_ips = var.administrator_ips

  prometheus_ips = [
    var.prometheus_ip_london,
    var.prometheus_ip_ireland
  ]

  use_env_prefix = var.use_env_prefix
}

module "govwifi_slack_alerts" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../govwifi-slack-alerts"

  critical-notifications-topic-arn         = module.critical-notifications.topic-arn
  capacity-notifications-topic-arn         = module.capacity-notifications.topic-arn
  route53-critical-notifications-topic-arn = module.route53-critical-notifications.topic-arn
}

module "govwifi_elasticsearch" {
  providers = {
    aws = aws.AWS-main
  }

  source         = "../../govwifi-elasticsearch"
  domain-name    = "${var.Env-Name}-elasticsearch"
  Env-Name       = var.Env-Name
  aws-region     = var.aws-region
  aws-account-id = local.aws_account_id
  vpc-id         = module.backend.backend-vpc-id
  vpc-cidr-block = module.backend.vpc-cidr-block

  backend-subnet-id = module.backend.backend-subnet-ids[0]
}
