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
  required_version = "~> 1.0.11"

  backend "s3" {
    # Interpolation is not allowed here.
    #bucket = "${lower(local.product_name)}-${lower(local.env_name)}-${lower(var.aws_region_name)}-tfstate"
    #key    = "${lower(var.aws_region_name)}-tfstate"
    #region = "${var.aws_region}"
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
  alias  = "main"
  region = var.aws_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
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

# Global ====================================================================

module "govwifi_account" {
  providers = {
    aws = aws.main
  }

  source         = "../../govwifi-account"
  aws_account_id = local.aws_account_id
}

# ====================================================================

module "backend" {
  providers = {
    aws = aws.main
    # Instance-specific setup -------------------------------
  }

  source        = "../../govwifi-backend"
  env           = "production"
  env_name      = local.env_name
  env_subdomain = local.env_subdomain

  # AWS VPC setup -----------------------------------------
  aws_region      = var.aws_region
  aws_region_name = var.aws_region_name
  route53_zone_id = data.aws_route53_zone.main.zone_id
  vpc_cidr_block  = "10.84.0.0/16"

  administrator_cidrs = var.administrator_cidrs
  frontend_radius_ips = local.frontend_radius_ips

  bastion_ami                = "ami-096cb92bb3580c759"
  bastion_instance_type      = "t2.micro"
  bastion_ssh_key_name       = "govwifi-bastion-key-20210630"
  enable_bastion_monitoring  = true
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
  critical_notifications_arn = module.critical_notifications.topic_arn
  capacity_notifications_arn = module.capacity_notifications.topic_arn
  user_replica_source_db     = "wifi-production-user-db"

  # Seconds. Set to zero to disable monitoring
  db_monitoring_interval = 60

  # Passed to application
  user_db_hostname      = var.user_db_hostname
  user_rr_hostname      = var.user_rr_hostname
  user_db_instance_type = "db.t2.medium"
  user_db_storage_gb    = 1000
  user_db_replica_count = 1

  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland
  grafana_ip            = var.grafana_ip

  backup_mysql_rds = local.backup_mysql_rds

  db_storage_alarm_threshold = 32212254720
}

# London Frontend ======DIFFERENT AWS REGION===================================
module "frontend" {
  providers = {
    aws           = aws.main
    aws.us_east_1 = aws.us_east_1
  }

  source        = "../../govwifi-frontend"
  env_name      = local.env_name
  env_subdomain = local.env_subdomain

  # AWS VPC setup -----------------------------------------
  # LONDON
  aws_region = var.aws_region

  aws_region_name    = var.aws_region_name
  route53_zone_id    = data.aws_route53_zone.main.zone_id
  vpc_cidr_block     = "10.85.0.0/16"
  rack_env           = "production"
  sentry_current_env = "production"

  # Instance-specific setup -------------------------------
  radius_instance_count      = 3
  enable_detailed_monitoring = true

  # eg. dns records are generated for radius(N).x.service.gov.uk
  # where N = this base + 1 + server#
  dns_numbering_base = 3

  ami                   = var.ami
  ssh_key_name          = var.ssh_key_name
  frontend_docker_image = format("%s/frontend:production", local.docker_image_path)
  raddb_docker_image    = format("%s/raddb:production", local.docker_image_path)
  create_ecr            = 1

  admin_app_data_s3_bucket_name = module.govwifi_admin.app_data_s3_bucket_name

  logging_api_base_url = var.london_api_base_url
  auth_api_base_url    = var.london_api_base_url

  critical_notifications_arn            = module.critical_notifications.topic_arn
  us_east_1_critical_notifications_arn  = module.route53_critical_notifications.topic_arn
  us_east_1_pagerduty_notifications_arn = module.us_east_1_pagerduty.topic_arn

  bastion_server_ip = var.bastion_server_ip

  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland

  radius_cidr_blocks = [for ip in local.frontend_radius_ips : "${ip}/32"]
}

module "govwifi_admin" {
  providers = {
    aws = aws.main
  }

  source        = "../../govwifi-admin"
  env_name      = local.env_name
  env_subdomain = local.env_subdomain

  aws_region      = var.aws_region
  aws_region_name = var.aws_region_name
  vpc_id          = module.backend.backend_vpc_id
  instance_count  = 2

  route53_zone_id = data.aws_route53_zone.main.zone_id

  admin_docker_image   = format("%s/admin:production", local.docker_image_path)
  rack_env             = "production"
  sentry_current_env   = "production"
  ecr_repository_count = 1

  subnet_ids = module.backend.backend_subnet_ids

  db_instance_type         = "db.t2.large"
  db_storage_gb            = 120
  db_backup_retention_days = 1
  db_encrypt_at_rest       = true
  db_maintenance_window    = "sat:00:42-sat:01:12"
  db_backup_window         = "03:42-04:42"
  db_monitoring_interval   = 60

  rr_db_host = "rr.london.wifi.service.gov.uk"
  rr_db_name = "govwifi_wifi"

  user_db_host = var.user_rr_hostname
  user_db_name = "govwifi_production_users"

  critical_notifications_arn = module.critical_notifications.topic_arn
  capacity_notifications_arn = module.capacity_notifications.topic_arn
  notification_arn           = module.region_pagerduty.topic_arn

  rds_monitoring_role = module.backend.rds_monitoring_role

  london_radius_ip_addresses = var.london_radius_ip_addresses
  dublin_radius_ip_addresses = var.dublin_radius_ip_addresses
  sentry_dsn                 = local.admin_sentry_dsn
  public_google_api_key      = var.public_google_api_key

  logging_api_search_url = "https://api-elb.london.${local.env_subdomain}.service.gov.uk:8443/logging/authentication/events/search/"

  zendesk_api_endpoint = "https://govuk.zendesk.com/api/v2/"
  zendesk_api_user     = var.zendesk_api_user

  bastion_server_ip = var.bastion_server_ip
}

module "api" {
  providers = {
    aws = aws.main
  }

  source        = "../../govwifi-api"
  env           = "production"
  env_name      = local.env_name
  env_subdomain = local.env_subdomain

  backend_elb_count      = 1
  backend_instance_count = 3
  aws_account_id         = local.aws_account_id
  aws_region_name        = var.aws_region_name
  aws_region             = var.aws_region
  route53_zone_id        = data.aws_route53_zone.main.zone_id
  vpc_id                 = module.backend.backend_vpc_id

  capacity_notifications_arn = module.capacity_notifications.topic_arn
  devops_notifications_arn   = module.devops_notifications.topic_arn
  notification_arn           = module.region_pagerduty.topic_arn

  auth_docker_image             = format("%s/authorisation-api:production", local.docker_image_path)
  user_signup_docker_image      = format("%s/user-signup-api:production", local.docker_image_path)
  logging_docker_image          = format("%s/logging-api:production", local.docker_image_path)
  safe_restart_docker_image     = format("%s/safe-restarter:production", local.docker_image_path)
  backup_rds_to_s3_docker_image = format("%s/database-backup:production", local.docker_image_path)

  create_wordlist_bucket = true
  wordlist_file_path     = "../wordlist-short"
  ecr_repository_count   = 1

  db_hostname               = "db.${lower(var.aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  rack_env                  = "production"
  sentry_current_env        = "production"
  radius_server_ips         = local.frontend_radius_ips
  subnet_ids                = module.backend.backend_subnet_ids
  private_subnet_ids        = module.backend.backend_private_subnet_ids
  nat_gateway_elastic_ips   = module.backend.nat_gateway_elastic_ips
  notify_ips                = var.notify_ips
  user_db_hostname          = var.user_db_hostname
  user_rr_hostname          = var.user_rr_hostname
  user_signup_api_is_public = 1

  admin_app_data_s3_bucket_name = module.govwifi_admin.app_data_s3_bucket_name

  backend_sg_list = [
    module.backend.be_admin_in,
  ]

  metrics_bucket_name     = module.govwifi_dashboard.metrics_bucket_name
  export_data_bucket_name = module.govwifi_dashboard.export_data_bucket_name

  backup_mysql_rds        = local.backup_mysql_rds
  rds_mysql_backup_bucket = module.backend.rds_mysql_backup_bucket

  low_cpu_threshold = 10

  elasticsearch_endpoint = module.govwifi_elasticsearch.endpoint
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

  topic_name = "govwifi-wifi-critical-london"
  emails     = [var.critical_notification_email]
}

locals {
  pagerduty_https_endpoint = jsondecode(data.aws_secretsmanager_secret_version.pagerduty_config.secret_string)["integration-url"]
}

module "region_pagerduty" {
  providers = {
    aws = aws.main
  }

  source = "../../govwifi-pagerduty-integration"

  sns_topic_subscription_https_endpoint = local.pagerduty_https_endpoint
}

module "us_east_1_pagerduty" {
  providers = {
    aws = aws.us_east_1
  }

  source = "../../govwifi-pagerduty-integration"

  sns_topic_subscription_https_endpoint = local.pagerduty_https_endpoint
}

module "govwifi_dashboard" {
  providers = {
    aws = aws.main
  }

  source   = "../../govwifi-dashboard"
  env_name = local.env_name
}

/*
We are only configuring a Prometheus server in London for now.
The server will scrape metrics from the agents configured in both regions.
The module `govwifi-prometheus` only needs to exist in
govwifi/staging-london/main.tf and govwifi/wifi-london/main.tf.
*/
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

  grafana_ip = var.grafana_ip
}

module "govwifi_grafana" {
  providers = {
    aws = aws.main
  }

  source                     = "../../govwifi-grafana"
  env_name                   = local.env_name
  env_subdomain              = local.env_subdomain
  aws_region                 = var.aws_region
  critical_notifications_arn = module.critical_notifications.topic_arn

  route53_zone_id = data.aws_route53_zone.main.zone_id

  ssh_key_name = var.ssh_key_name

  subnet_ids = module.backend.backend_subnet_ids

  backend_subnet_ids = module.backend.backend_subnet_ids

  be_admin_in = module.backend.be_admin_in

  vpc_id = module.backend.backend_vpc_id

  bastion_ip = var.bastion_server_ip

  administrator_cidrs = var.administrator_cidrs

  prometheus_ips = [
    var.prometheus_ip_london,
    var.prometheus_ip_ireland
  ]

}

module "govwifi_slack_alerts" {
  providers = {
    aws = aws.main
  }

  source = "../../govwifi-slack-alerts"

  critical_notifications_topic_arn         = module.critical_notifications.topic_arn
  capacity_notifications_topic_arn         = module.capacity_notifications.topic_arn
  route53_critical_notifications_topic_arn = module.route53_critical_notifications.topic_arn
}

module "govwifi_elasticsearch" {
  providers = {
    aws = aws.main
  }

  source         = "../../govwifi-elasticsearch"
  domain_name    = "${local.env_name}-elasticsearch"
  env_name       = local.env_name
  aws_region     = var.aws_region
  aws_account_id = local.aws_account_id
  vpc_id         = module.backend.backend_vpc_id
  vpc_cidr_block = module.backend.vpc_cidr_block

  backend_subnet_id = module.backend.backend_subnet_ids[0]
}
