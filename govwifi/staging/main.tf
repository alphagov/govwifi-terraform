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
  accesslogs-glacier-transition-days = 7
  accesslogs-expiration-days         = 30
}

terraform {
  backend "s3" {
    # Interpolation is not allowed here.
    #bucket = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate"
    #key    = "${lower(var.aws-region-name)}-tfstate"
    #region = "${var.aws-region}"
    bucket = "govwifi-staging-dublin-tfstate"

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

# Backend ==================================================================
module "backend" {
  providers = {
    aws = aws.AWS-main
  }

  source                    = "../../govwifi-backend"
  env                       = "staging"
  env_name                  = var.Env-Name
  env_subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  # AWS VPC setup -----------------------------------------
  aws_region      = var.aws-region
  route53_zone_id = local.route53_zone_id
  aws_region_name = var.aws-region-name
  vpc_cidr_block  = "10.100.0.0/16"
  zone_count      = var.zone-count
  zone_names      = var.zone-names

  zone_subnets = {
    zone0 = "10.100.1.0/24"
    zone1 = "10.100.2.0/24"
    zone2 = "10.100.3.0/24"
  }

  administrator_ips   = var.administrator_ips
  frontend_radius_ips = local.frontend_radius_ips

  # Instance-specific setup -------------------------------
  # eu-west-1, CIS Ubuntu Linux 16.04 LTS Benchmark v1.0.0.4 - Level 1
  enable_bastion = 0
  #bastion-ami = "ami-51d3e928"
  # eu-west-2 eu-west-2, CIS Ubuntu Linux 20.04 LTS
  bastion_ami = "ami-08bac620dc84221eb"

  bastion_instance_type     = "t2.micro"
  bastion_server_ip         = var.bastion_server_ip
  bastion_ssh_key_name      = "govwifi-staging-bastion-key-20181025"
  enable_bastion_monitoring = false
  users                     = var.users
  aws_account_id            = local.aws_account_id

  db_encrypt_at_rest       = true
  db_maintenance_window    = "sat:00:42-sat:01:12"
  db_backup_window         = "03:42-04:42"
  db_backup_retention_days = 1

  db_instance_count        = 0
  session_db_instance_type = ""
  session_db_storage_gb    = 0

  db_replica_count = 0
  rr_instance_type = ""
  rr_storage_gb    = 0

  user_db_replica_count  = 1
  user_replica_source_db = "arn:aws:rds:eu-west-2:${local.aws_account_id}:db:wifi-staging-user-db"
  user_rr_instance_type  = "db.t2.small"

  user_rr_hostname           = var.user-rr-hostname
  critical_notifications_arn = module.notifications.topic-arn
  capacity_notifications_arn = module.notifications.topic-arn

  # Seconds. Set to zero to disable monitoring
  db_monitoring_interval = 60

  # Passed to application
  user_db_hostname      = ""
  user_db_instance_type = ""
  user_db_storage_gb    = 0
  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland
  grafana_ip            = var.grafana_ip

  use_env_prefix = var.use_env_prefix

  db_storage_alarm_threshold = 19327342936
}

# Emails ======================================================================
module "emails" {
  providers = {
    aws = aws.AWS-main
  }

  is_production_aws_account = var.is_production_aws_account
  source                    = "../../govwifi-emails"
  product-name              = var.product-name
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  aws-account-id            = local.aws_account_id
  route53-zone-id           = local.route53_zone_id
  aws-region                = var.aws-region
  aws-region-name           = var.aws-region-name
  mail-exchange-server      = "10 inbound-smtp.eu-west-1.amazonaws.com"
  devops-notifications-arn  = module.notifications.topic-arn

  #sns-endpoint             = "https://elb.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk/sns/"
  sns-endpoint                       = "https://elb.london.${var.Env-Subdomain}.service.gov.uk/sns/"
  user-signup-notifications-endpoint = "https://user-signup-api.${var.Env-Subdomain}.service.gov.uk:8443/user-signup/email-notification"
}

module "govwifi_keys" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../govwifi-keys"

  create_production_bastion_key = 0
  is_production_aws_account     = var.is_production_aws_account

  govwifi-bastion-key-name = "govwifi-bastion-key-20210630"
  govwifi-bastion-key-pub  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDY/Q676Tp5CTpKWVksMPztERDdjWOrYFgVckF9IHGI2wC38ckWFiqawsEZBILUyNZgL/lnOtheN1UZtuGmUUkPxgtPw+YD6gMDcebhSX4wh9GM3JjXAIy9+V/WagQ84Pz10yIp+PlyzcQMu+RVRVzWyTYZUdgMsDt0tFdcgMgUc7FkC252CgtSZHpLXhnukG5KG69CoTO+kuak/k3vX5jwWjIgfMGZwIAq+F9XSIMAwylCmmdE5MetKl0Wx4EI/fm8WqSZXj+yeFRv9mQTus906AnNieOgOrgt4D24/JuRU1JTlZ35iNbOKcwlOTDSlTQrm4FA1sCllphhD/RQVYpMp6EV3xape626xwkucCC2gYnakxTZFHUIeWfC5aHGrqMOMtXRfW0xs+D+vzo3MCWepdIebWR5KVhqkbNUKHBG9e8oJbTYUkoyBZjC7LtI4fgB3+blXyFVuQoAzjf+poPzdPBfCC9eiUJrEHoOljO9yMcdkBfyW3c/o8Sd9PgNufc= bastion@govwifi"

  govwifi-key-name     = "govwifi-key-20180530"
  govwifi-key-name-pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJmLa/tF941z6Dh/jiZCH6Mw/JoTXGkILim/bgDc3PSBKXFmBwkAFUVgnoOUWJDXvZWpuBJv+vUu+ZlmlszFM00BRXpb4ykRuJxWIjJiNzGlgXW69Satl2e9d37ZtLwlAdABgJyvj10QEiBtB1VS0DBRXK9J+CfwNPnwVnfppFGP86GoqE2Il86t+BB/VC//gKMTttIstyl2nqUwkK3Epq66+1ol3AelmUmBjPiyrmkwp+png9F4B86RqSNa/drfXmUGf1czE4+H+CXqOdje2bmnrwxLQ8GY3MYpz0zTVrB3T1IyXXF6dcdcF6ZId9B/10jMiTigvOeUvraFEf9fK7 govwifi@govwifi"

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
  vpc-cidr-block     = "10.101.0.0/16"
  zone-count         = var.zone-count
  zone-names         = var.zone-names
  rack-env           = "staging"
  sentry-current-env = "staging"

  zone-subnets = {
    zone0 = "10.101.1.0/24"
    zone1 = "10.101.2.0/24"
    zone2 = "10.101.3.0/24"
  }

  # Instance-specific setup -------------------------------
  radius-instance-count      = 3
  enable-detailed-monitoring = false

  # eg. dns records are generated for radius(N).x.service.gov.uk
  # where N = this base + 1 + server#
  dns-numbering-base = 0

  elastic-ip-list       = local.frontend_region_ips
  ami                   = var.ami
  ssh-key-name          = var.ssh-key-name
  frontend-docker-image = format("%s/frontend:staging", local.docker_image_path)
  raddb-docker-image    = format("%s/raddb:staging", local.docker_image_path)

  # admin bucket
  admin-bucket-name = "govwifi-staging-admin"

  logging-api-base-url = var.london-api-base-url
  auth-api-base-url    = var.dublin-api-base-url

  critical_notifications_arn           = module.notifications.topic-arn
  us_east_1_critical_notifications_arn = module.route53-notifications.topic-arn

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

  source                    = "../../govwifi-api"
  env                       = "staging"
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  backend-elb-count      = 1
  backend-instance-count = 2
  aws-account-id         = local.aws_account_id
  aws-region-name        = var.aws-region-name
  aws-region             = var.aws-region
  route53-zone-id        = local.route53_zone_id
  vpc-id                 = module.backend.backend-vpc-id

  user-signup-enabled  = 0
  logging-enabled      = 0
  alarm-count          = 0
  safe-restart-enabled = 0
  event-rule-count     = 0

  devops-notifications-arn = module.notifications.topic-arn
  notification_arn         = module.notifications.topic-arn

  auth-docker-image             = format("%s/authorisation-api:staging", local.docker_image_path)
  user-signup-docker-image      = ""
  logging-docker-image          = ""
  safe-restart-docker-image     = ""
  backup-rds-to-s3-docker-image = ""

  db-hostname = ""

  user-db-hostname = ""
  user-rr-hostname = var.user-rr-hostname

  rack-env                  = "staging"
  sentry-current-env        = "staging"
  radius-server-ips         = local.frontend_radius_ips
  authentication_sentry_dsn = var.auth_sentry_dsn
  safe_restart_sentry_dsn   = ""
  subnet-ids                = module.backend.backend-subnet-ids
  admin-bucket-name         = ""

  backend-sg-list = [
    module.backend.be-admin-in,
  ]

  use_env_prefix = var.use_env_prefix

  low_cpu_threshold = 0.3
}

module "notifications" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../sns-notification"

  topic_name = "govwifi-staging"
  emails     = [var.notification_email]
}

module "route53-notifications" {
  providers = {
    aws = aws.route53-alarms
  }

  source = "../../sns-notification"

  topic_name = "govwifi-staging"
  emails     = [var.notification_email]
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
  # Value defaults to 0 and should only be enabled (i.e., value = 1)
  create_prometheus_server = 0

  prometheus_ip = var.prometheus_ip_ireland
  grafana_ip    = var.grafana_ip
}
