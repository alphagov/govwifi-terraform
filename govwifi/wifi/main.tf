module "tfstate" {
  providers = {
    aws = aws.main
  }

  source             = "../../terraform-state"
  product_name       = local.product_name
  env_name           = local.env_name
  aws_account_id     = local.aws_account_id
  aws_region_name    = var.aws_region_name
  backup_region_name = var.backup_region_name

  # TODO: separate module for accesslogs
  accesslogs_glacier_transition_days = 30
  accesslogs_expiration_days         = 90
}

terraform {
  required_version = "~> 0.15.5"

  backend "s3" {
    # Interpolation is not allowed here.
    #bucket = "${lower(local.product_name)}-${lower(var.env_name)}-${lower(var.aws_region_name)}-tfstate"
    #key    = "${lower(var.aws_region_name)}-tfstate"
    #region = "${var.aws_region}"
    bucket = "govwifi-wifi-dublin-tfstate"

    key    = "dublin-tfstate"
    region = "eu-west-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias  = "main"
  region = var.aws_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

data "terraform_remote_state" "london" {
  backend = "s3"

  config = {
    bucket = "govwifi-wifi-london-tfstate"
    key    = "london-tfstate"
    region = "eu-west-2"
  }
}

module "govwifi_keys" {
  providers = {
    aws = aws.main
  }

  source = "../../govwifi-keys"

  create_production_bastion_key = 1

  govwifi_bastion_key_name = "govwifi-bastion-key-20210630"
  govwifi_bastion_key_pub  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDY/Q676Tp5CTpKWVksMPztERDdjWOrYFgVckF9IHGI2wC38ckWFiqawsEZBILUyNZgL/lnOtheN1UZtuGmUUkPxgtPw+YD6gMDcebhSX4wh9GM3JjXAIy9+V/WagQ84Pz10yIp+PlyzcQMu+RVRVzWyTYZUdgMsDt0tFdcgMgUc7FkC252CgtSZHpLXhnukG5KG69CoTO+kuak/k3vX5jwWjIgfMGZwIAq+F9XSIMAwylCmmdE5MetKl0Wx4EI/fm8WqSZXj+yeFRv9mQTus906AnNieOgOrgt4D24/JuRU1JTlZ35iNbOKcwlOTDSlTQrm4FA1sCllphhD/RQVYpMp6EV3xape626xwkucCC2gYnakxTZFHUIeWfC5aHGrqMOMtXRfW0xs+D+vzo3MCWepdIebWR5KVhqkbNUKHBG9e8oJbTYUkoyBZjC7LtI4fgB3+blXyFVuQoAzjf+poPzdPBfCC9eiUJrEHoOljO9yMcdkBfyW3c/o8Sd9PgNufc= bastion@govwifi"

  govwifi_key_name     = var.ssh_key_name
  govwifi_key_name_pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJmLa/tF941z6Dh/jiZCH6Mw/JoTXGkILim/bgDc3PSBKXFmBwkAFUVgnoOUWJDXvZWpuBJv+vUu+ZlmlszFM00BRXpb4ykRuJxWIjJiNzGlgXW69Satl2e9d37ZtLwlAdABgJyvj10QEiBtB1VS0DBRXK9J+CfwNPnwVnfppFGP86GoqE2Il86t+BB/VC//gKMTttIstyl2nqUwkK3Epq66+1ol3AelmUmBjPiyrmkwp+png9F4B86RqSNa/drfXmUGf1czE4+H+CXqOdje2bmnrwxLQ8GY3MYpz0zTVrB3T1IyXXF6dcdcF6ZId9B/10jMiTigvOeUvraFEf9fK7 govwifi@govwifi"

}

# Backend =====================================================================
module "backend" {
  providers = {
    aws = aws.main
  }

  source                    = "../../govwifi-backend"
  env                       = "production"
  env_name                  = local.env_name
  env_subdomain             = local.env_subdomain
  is_production_aws_account = var.is_production_aws_account


  # AWS VPC setup -----------------------------------------
  aws_region      = var.aws_region
  aws_region_name = var.aws_region_name
  route53_zone_id = data.aws_route53_zone.main.zone_id
  vpc_cidr_block  = "10.42.0.0/16"

  administrator_ips   = var.administrator_ips
  frontend_radius_ips = local.frontend_radius_ips

  # Instance-specific setup -------------------------------
  # eu-west-1, CIS Ubuntu Linux 16.04 LTS Benchmark v1.0.0.4 - Level 1
  # bastion-ami = "ami-51d3e928"
  # eu-west-2 eu-west-2, CIS Ubuntu Linux 20.04 LTS
  bastion_ami               = "ami-08bac620dc84221eb"
  bastion_instance_type     = "t2.micro"
  bastion_server_ip         = var.bastion_server_ip
  bastion_ssh_key_name      = "govwifi-bastion-key-20210630"
  enable_bastion_monitoring = true
  users                     = var.users
  aws_account_id            = local.aws_account_id

  db_instance_count        = 0
  session_db_instance_type = "db.m4.xlarge"
  session_db_storage_gb    = 1000
  db_backup_retention_days = 7
  db_encrypt_at_rest       = true
  db_maintenance_window    = "wed:01:42-wed:02:12"
  db_backup_window         = "04:42-05:42"

  db_replica_count      = 0
  user_db_replica_count = 1
  rr_instance_type      = "db.m3.medium"
  rr_storage_gb         = 1000

  critical_notifications_arn = module.critical_notifications.topic_arn
  capacity_notifications_arn = module.capacity_notifications.topic_arn
  user_replica_source_db     = "arn:aws:rds:eu-west-2:${local.aws_account_id}:db:wifi-production-user-db"

  # Seconds. Set to zero to disable monitoring
  db_monitoring_interval = 60

  # Passed to application
  user_db_instance_type = "db.t2.medium"
  user_db_hostname      = var.user_db_hostname
  user_db_storage_gb    = 20
  user_rr_hostname      = var.user_rr_hostname
  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland
  grafana_ip            = var.grafana_ip

  db_storage_alarm_threshold = 32212254720
}

# Emails ======================================================================
module "emails" {
  providers = {
    aws = aws.main
  }

  source = "../../govwifi-emails"

  is_production_aws_account = var.is_production_aws_account
  product_name              = local.product_name
  env_name                  = local.env_name
  env_subdomain             = local.env_subdomain
  aws_account_id            = local.aws_account_id
  route53_zone_id           = data.aws_route53_zone.main.zone_id
  aws_region                = var.aws_region
  aws_region_name           = var.aws_region_name
  mail_exchange_server      = "10 inbound-smtp.eu-west-1.amazonaws.com"
  devops_notifications_arn  = module.devops_notifications.topic_arn

  #sns-endpoint             = "https://elb.${lower(var.aws_region_name)}.${var.env_subdomain}.service.gov.uk/sns/"
  sns_endpoint                       = "https://elb.london.${local.env_subdomain}.service.gov.uk/sns/"
  user_signup_notifications_endpoint = "https://user-signup-api.${local.env_subdomain}.service.gov.uk:8443/user-signup/email-notification"
}

# Global ====================================================================
#moved for wifi-london
#module "govwifi_account" {
#  providers = {
#    "aws" = "aws.main"
#  }
#
#  source     = "../../govwifi-account"
#  account-id = "${var.aws-parent-account-id}"
#}

module "dns" {
  providers = {
    aws = aws.main
  }

  source             = "../../global-dns"
  env_subdomain      = local.env_subdomain
  route53_zone_id    = data.aws_route53_zone.main.zone_id
  status_page_domain = "bl6klm1cjshh.stspg-customer.com"
}

# Frontend ====================================================================
module "frontend" {
  providers = {
    aws           = aws.main
    aws.us_east_1 = aws.us_east_1
  }

  source                    = "../../govwifi-frontend"
  env_name                  = local.env_name
  env_subdomain             = local.env_subdomain
  is_production_aws_account = var.is_production_aws_account


  # AWS VPC setup -----------------------------------------
  aws_region         = var.aws_region
  aws_region_name    = var.aws_region_name
  route53_zone_id    = data.aws_route53_zone.main.zone_id
  vpc_cidr_block     = "10.43.0.0/16"
  rack_env           = "production"
  sentry_current_env = "production"

  # Instance-specific setup -------------------------------
  radius_instance_count      = 3
  enable_detailed_monitoring = true

  # eg. dns records are generated for radius(N).x.service.gov.uk
  # where N = this base + 1 + server#
  dns_numbering_base = 0

  ami                   = var.ami
  ssh_key_name          = var.ssh_key_name
  frontend_docker_image = format("%s/frontend:production", local.docker_image_path)
  raddb_docker_image    = format("%s/raddb:production", local.docker_image_path)

  admin_app_data_s3_bucket_name = data.terraform_remote_state.london.outputs.admin_app_data_s3_bucket_name

  logging_api_base_url = var.london_api_base_url
  auth_api_base_url    = var.dublin_api_base_url

  critical_notifications_arn            = module.critical_notifications.topic_arn
  us_east_1_critical_notifications_arn  = module.route53_critical_notifications.topic_arn
  us_east_1_pagerduty_notifications_arn = data.terraform_remote_state.london.outputs.us_east_1_pagerduty_topic_arn

  bastion_server_ip = var.bastion_server_ip

  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland

  radius_cidr_blocks = [for ip in local.frontend_radius_ips : "${ip}/32"]
}

module "api" {
  providers = {
    aws = aws.main
  }

  env                       = "production"
  source                    = "../../govwifi-api"
  env_name                  = local.env_name
  env_subdomain             = local.env_subdomain
  is_production_aws_account = var.is_production_aws_account

  backend_elb_count       = 1
  backend_instance_count  = 2
  authorisation_api_count = 3
  aws_account_id          = local.aws_account_id
  aws_region_name         = lower(var.aws_region_name)
  aws_region              = var.aws_region
  route53_zone_id         = data.aws_route53_zone.main.zone_id
  vpc_id                  = module.backend.backend_vpc_id

  user_signup_enabled  = 0
  logging_enabled      = 0
  alarm_count          = 0
  safe_restart_enabled = 0
  event_rule_count     = 0

  devops_notifications_arn = module.devops_notifications.topic_arn
  notification_arn         = module.region_pagerduty.topic_arn

  auth_docker_image             = format("%s/authorisation-api:production", local.docker_image_path)
  logging_docker_image          = format("%s/logging-api:production", local.docker_image_path)
  safe_restart_docker_image     = format("%s/safe-restarter:production", local.docker_image_path)
  backup_rds_to_s3_docker_image = ""

  db_hostname               = "db.${lower(var.aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  rack_env                  = "production"
  sentry_current_env        = "production"
  radius_server_ips         = local.frontend_radius_ips
  authentication_sentry_dsn = var.auth_sentry_dsn
  safe_restart_sentry_dsn   = var.safe_restart_sentry_dsn
  user_signup_docker_image  = ""
  subnet_ids                = module.backend.backend_subnet_ids
  user_db_hostname          = var.user_db_hostname
  user_rr_hostname          = var.user_rr_hostname
  backup_mysql_rds          = false
  rds_mysql_backup_bucket   = module.backend.rds_mysql_backup_bucket

  backend_sg_list = [
    module.backend.be_admin_in,
  ]

  low_cpu_threshold = 10
}

module "critical_notifications" {
  providers = {
    aws = aws.main
  }

  source = "../../sns-notification"

  topic_name = "govwifi-wifi-critical"
  emails     = [var.critical_notification_email]
}

module "capacity_notifications" {
  providers = {
    aws = aws.main
  }

  source = "../../sns-notification"

  topic_name = "govwifi-wifi-capacity"
  emails     = [var.capacity_notification_email]
}

module "devops_notifications" {
  providers = {
    aws = aws.main
  }

  source = "../../sns-notification"

  topic_name = "govwifi-wifi-devops"
  emails     = [var.devops_notification_email]
}

module "route53_critical_notifications" {
  providers = {
    aws = aws.us_east_1
  }

  source = "../../sns-notification"

  topic_name = "govwifi-wifi-critical"
  emails     = [var.critical_notification_email]
}

module "region_pagerduty" {
  providers = {
    aws = aws.main
  }

  source = "../../govwifi-pagerduty-integration"

  sns_topic_subscription_https_endpoint = local.pagerduty_https_endpoint
}

module "govwifi_prometheus" {
  providers = {
    aws = aws.main
  }

  source   = "../../govwifi-prometheus"
  env_name = local.env_name

  ssh_key_name = var.ssh_key_name

  frontend_vpc_id = module.frontend.frontend_vpc_id

  fe_admin_in   = module.frontend.fe_admin_in
  fe_ecs_out    = module.frontend.fe_ecs_out
  fe_radius_in  = module.frontend.fe_radius_in
  fe_radius_out = module.frontend.fe_radius_out

  wifi_frontend_subnet       = module.frontend.frontend_subnet_id
  london_radius_ip_addresses = var.london_radius_ip_addresses
  dublin_radius_ip_addresses = var.dublin_radius_ip_addresses

  prometheus_ip = var.prometheus_ip_ireland
  grafana_ip    = var.grafana_ip
}
