locals {
  london_aws_region      = "eu-west-2"
  london_aws_region_name = "London"
}

provider "aws" {
  alias  = "london"
  region = local.london_aws_region

  default_tags {
    tags = {
      Environment = title(local.env_name)
    }
  }
}

module "london_keys" {
  providers = {
    aws = aws.london
  }

  source = "../../govwifi-keys"

  govwifi_bastion_key_name = "govwifi-recovery-bastion-20230418"
  govwifi_bastion_key_pub  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3vQxrmUYgWbMN1kLsm7SBAXLFgzScRUH7FV7B1q1J4AFYoGHTSpRVRlFJSH39HjxNZTPqHZDAZZG1dk6Mpoc+PaaJypZrjdA2cPWwoMWzaZ4EJ4UyzU/PscR/Cj8MO84ETq5cPsLvqI/2DxAmJHjQQMTmR/cr22A5TThmx8Wuz20yOuGpfWGXfL6xty984f7Vth29WBLDGApIbmwq7P+9BttzRlXxfJ1ZwW45ixUXWPgeLdhmQBuL87WOOeA9I6GxMiAen62E4dbjls25mE3SM3Uvqneyhnq3U1jfBqfL2qxfDZX6jGwfKKE5MmXURdaT97txHsIEWLb3BHaxHsvFXw7O5Oys29hoz5mGlPy3AC7679M2wgZQ1rrxYnR1TNCzKD0UMcO9zT1OnpfIoENRGRBBacaVARI8fcbbT+RR1Mwaq+KAEOaojkyqktiiQ9wVpPMr15j2zrvCKgokUlbhIqPgmyQVSrxWC/gw2NYf+BG1AL5JRb2+DI8DgZz5CfM= govwifi-developers@digital.cabinet-office.gov.uk"

  create_production_bastion_key = 0

  govwifi_key_name     = var.ssh_key_name
  govwifi_key_name_pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOxYtGJARr+ZUB9wMWMX/H+myTidFKx+qcBsXuri5zavQ6K4c0WhSkypXfET9BBtC1ZU77B98mftegxKdKcKmFbCVlv39pIX+xj2vjuCzHlzezI1vB4mdAXNhc8b4ArvFJ8lG2GLa1ZD8H/8akpv6EcplwyUv6ZgQMPl6wfMF6d0Qe/eOJ/bV570icX9NYLGkdLRbudkRc12krt6h451qp1vO7f2FQOnPR2cnyLGd/FxhrmAOqJsDk9CRNSwHJe1lsSCz6TkQk1bfCTxZ7g2hWSNRBdWPj0RJbbezy3X3/pz4cFL8mCC1esJ+nptUZ7CXeyirtCObIepniXIItwtdIVqixaMSjfagUGd0L1zFEVuH0bct3mh3u3TyVbNHP4o4pFHvG0sm5R1iDB8/xe2NJdxmAsn3JqeXdsQ6uI/oz31OueFRPyZI0VeDw7B4bhBMZ0w/ncrYJ9jFjfPvzhAVZgQX5Pxtp5MUCeU9+xIdAN2bESmIvaoSEwno7WJ4z61d83pLMFUuS9vNRW4ykgd1BzatLYSkLp/fn/wYNn6DBk7Da6Vs1Y/jgkiDJPGeFlEhW3rqOjTKrpKJBw6LBsMyI0BtkKoPoUTDlKSEX5JlNWBX2z5eSEhe+WEQjc4ZnbLUOKRB5+xNOGahVyk7/VF8ZaZ3/GXWY7MEfZ8TIBBcAjw== GovWifi-DevOps@digital.cabinet-office.gov.uk"

}

module "london_backend" {
  providers = {
    aws = aws.london
  }

  source        = "../../govwifi-backend"
  env           = "recovery"
  env_name      = local.env_name
  env_subdomain = local.env_subdomain

  # AWS VPC setup -----------------------------------------
  aws_region      = local.london_aws_region
  route53_zone_id = data.aws_route53_zone.main.zone_id
  aws_region_name = local.london_aws_region_name
  vpc_cidr_block  = "10.106.0.0/16"

  administrator_cidrs = var.administrator_cidrs
  frontend_radius_ips = local.frontend_radius_ips

  bastion_ami               = "ami-096cb92bb3580c759"
  bastion_instance_type     = "t2.micro"
  bastion_ssh_key_name      = "govwifi-recovery-bastion-20230418"
  enable_bastion_monitoring = false
  aws_account_id            = local.aws_account_id
  db_instance_count         = 1
  session_db_instance_type  = "db.t2.small"
  session_db_storage_gb     = 20
  db_backup_retention_days  = 1
  db_encrypt_at_rest        = true
  db_maintenance_window     = "sat:01:42-sat:02:12"
  db_backup_window          = "04:42-05:42"
  db_replica_count          = 0
  rr_instance_type          = "db.t2.large"
  rr_storage_gb             = 200
  # TODO This should happen inside the module
  user_rr_hostname           = "users-rr.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  critical_notifications_arn = module.london_notifications.topic_arn
  capacity_notifications_arn = module.london_notifications.topic_arn

  # Seconds. Set to zero to disable monitoring
  db_monitoring_interval = 60

  # Passed to application
  # TODO This should happen inside the module
  user_db_hostname      = "users-db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  user_db_instance_type = "db.t2.small"
  user_db_storage_gb    = 20

  prometheus_ip_london  = module.london_prometheus.eip_public_ip
  prometheus_ip_ireland = module.dublin_prometheus.eip_public_ip
  grafana_ip            = module.london_grafana.eip_public_ip

  backup_mysql_rds = local.backup_mysql_rds

  db_storage_alarm_threshold = 19327342936
}

module "london_frontend" {
  providers = {
    aws           = aws.london
    aws.us_east_1 = aws.us_east_1
  }

  source        = "../../govwifi-frontend"
  env_name      = local.env_name
  env_subdomain = local.env_subdomain
  env           = local.env

  # AWS VPC setup -----------------------------------------
  # LONDON
  aws_region = local.london_aws_region

  aws_region_name    = local.london_aws_region_name
  route53_zone_id    = data.aws_route53_zone.main.zone_id
  vpc_cidr_block     = "10.102.0.0/16"
  rack_env           = "recovery"
  sentry_current_env = "secondary-recovery"

  backend_vpc_id = module.london_backend.backend_vpc_id

  # Instance-specific setup -------------------------------
  radius_instance_count      = 3
  enable_detailed_monitoring = false

  # eg. dns records are generated for radius(N).x.service.gov.uk
  # where N = this base + 1 + server#
  dns_numbering_base = 3

  ami                   = "ami-2218f945"
  ssh_key_name          = var.ssh_key_name
  frontend_docker_image = format("%s/frontend:recovery", local.docker_image_path)
  raddb_docker_image    = format("%s/raddb:recovery", local.docker_image_path)
  create_ecr            = 1

  admin_app_data_s3_bucket_name = module.london_admin.app_data_s3_bucket_name

  logging_api_base_url = module.london_api.api_base_url
  auth_api_base_url    = module.london_api.api_base_url

  authentication_api_internal_dns_name = module.london_api.authentication_api_internal_dns_name
  logging_api_internal_dns_name        = one(module.london_api.logging_api_internal_dns_name)

  notification_arn           = module.london_notifications.topic_arn
  critical_notifications_arn = module.london_notifications.topic_arn

  bastion_server_ip = module.london_backend.bastion_public_ip

  prometheus_ip_london  = module.london_prometheus.eip_public_ip
  prometheus_ip_ireland = module.london_prometheus.eip_public_ip

  prometheus_security_group_id = module.london_prometheus.prometheus_security_group_id

  radius_cidr_blocks = [for ip in local.frontend_radius_ips : "${ip}/32"]
}

module "london_admin" {
  providers = {
    aws             = aws.london
    aws.replication = aws.dublin
  }

  source        = "../../govwifi-admin"
  env_name      = local.env_name
  env_subdomain = local.env_subdomain
  env           = local.env

  aws_region      = local.london_aws_region
  aws_region_name = local.london_aws_region_name
  vpc_id          = module.london_backend.backend_vpc_id
  instance_count  = 1

  vpc_endpoints_security_group_id = module.london_backend.vpc_endpoints_security_group_id

  route53_zone_id = data.aws_route53_zone.main.zone_id

  admin_docker_image   = format("%s/admin:recovery", local.docker_image_path)
  rails_env            = "recovery"
  app_env              = "staging"
  sentry_current_env   = "secondary-recovery"
  ecr_repository_count = 1

  subnet_ids = module.london_backend.backend_subnet_ids

  db_instance_type         = "db.t2.medium"
  db_storage_gb            = 120
  db_backup_retention_days = 1
  db_encrypt_at_rest       = true
  db_maintenance_window    = "sat:00:42-sat:01:12"
  db_backup_window         = "03:42-04:42"
  db_monitoring_interval   = 60

  rr_db_host = "db.london.recovery.wifi.service.gov.uk"
  rr_db_name = "govwifi_recovery"

  user_db_host = "users-db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  user_db_name = "govwifi_staging_users"

  critical_notifications_arn = module.london_notifications.topic_arn
  capacity_notifications_arn = module.london_notifications.topic_arn

  rds_monitoring_role = module.london_backend.rds_monitoring_role

  london_radius_ip_addresses = module.london_frontend.eip_public_ips
  dublin_radius_ip_addresses = module.dublin_frontend.eip_public_ips
  logging_api_search_url     = "https://api-elb.london.${local.env_subdomain}.service.gov.uk:8443/logging/authentication/events/search/"
  public_google_api_key      = var.public_google_api_key

  zendesk_api_endpoint = "https://govuk.zendesk.com/api/v2/"
  zendesk_api_user     = var.zendesk_api_user

  bastion_server_ip = module.london_backend.bastion_public_ip

  notification_arn = module.london_notifications.topic_arn

  elasticsearch_endpoint = module.london_elasticsearch.endpoint
}

module "london_api" {
  providers = {
    aws = aws.london
  }

  source        = "../../govwifi-api"
  env           = "recovery"
  env_name      = "recovery"
  env_subdomain = local.env_subdomain

  backend_elb_count      = 1
  backend_instance_count = 2
  aws_account_id         = local.aws_account_id
  aws_region_name        = local.london_aws_region_name
  aws_region             = local.london_aws_region
  route53_zone_id        = data.aws_route53_zone.main.zone_id
  vpc_id                 = module.london_backend.backend_vpc_id
  safe_restart_enabled   = 1

  vpc_endpoints_security_group_id = module.london_backend.vpc_endpoints_security_group_id

  capacity_notifications_arn = module.london_notifications.topic_arn
  devops_notifications_arn   = module.london_notifications.topic_arn
  notification_arn           = module.london_notifications.topic_arn

  user_signup_docker_image      = format("%s/user-signup-api:recovery", local.docker_image_path)
  logging_docker_image          = format("%s/logging-api:recovery", local.docker_image_path)
  safe_restart_docker_image     = format("%s/safe-restarter:recovery", local.docker_image_path)
  backup_rds_to_s3_docker_image = format("%s/database-backup:recovery", local.docker_image_path)

  create_wordlist_bucket = true
  wordlist_file_path     = "../wordlist-short"
  ecr_repository_count   = 1

  db_hostname = "db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"

  user_db_hostname = "users-db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  user_rr_hostname = "users-db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"

  rack_env                  = "recovery"
  app_env                   = "staging"
  sentry_current_env        = "secondary-recovery"
  radius_server_ips         = local.frontend_radius_ips
  subnet_ids                = module.london_backend.backend_subnet_ids
  private_subnet_ids        = module.london_backend.backend_private_subnet_ids
  nat_gateway_elastic_ips   = module.london_backend.nat_gateway_elastic_ips
  notify_ips                = var.notify_ips
  user_signup_api_is_public = 1

  admin_app_data_s3_bucket_name = module.london_admin.app_data_s3_bucket_name

  backend_sg_list = [
    module.london_backend.be_admin_in,
  ]

  metrics_bucket_name     = module.london_dashboard.metrics_bucket_name
  export_data_bucket_name = module.london_dashboard.export_data_bucket_name

  rds_mysql_backup_bucket = module.london_backend.rds_mysql_backup_bucket
  backup_mysql_rds        = local.backup_mysql_rds

  alb_permitted_security_groups = [
    module.london_frontend.load_balanced_frontend_service_security_group_id
  ]

  alb_permitted_cidr_blocks = [
    local.dublin_frontend_vpc_cidr_block
  ]

  low_cpu_threshold = 0.3

  elasticsearch_endpoint = module.london_elasticsearch.endpoint
}

module "london_route53_notifications" {
  providers = {
    aws = aws.us_east_1
  }

  source = "../../sns-notification"

  topic_name = "govwifi-recovery-london"
  emails     = [var.notification_email]
}

module "london_notifications" {
  providers = {
    aws = aws.london
  }

  source = "../../sns-notification"

  topic_name = "govwifi-recovery"
  emails     = [var.notification_email]
}

module "london_dashboard" {
  providers = {
    aws = aws.london
  }

  source   = "../../govwifi-dashboard"
  env_name = local.env_name
}

module "london_prometheus" {
  providers = {
    aws = aws.london
  }

  source   = "../../govwifi-prometheus"
  env_name = local.env_name

  ssh_key_name = var.ssh_key_name

  frontend_vpc_id = module.london_frontend.frontend_vpc_id

  fe_admin_in = module.london_frontend.fe_admin_in

  wifi_frontend_subnet       = module.london_frontend.frontend_subnet_id
  london_radius_ip_addresses = module.london_frontend.eip_public_ips
  dublin_radius_ip_addresses = module.dublin_frontend.eip_public_ips

  grafana_ip = module.london_grafana.eip_public_ip
}

module "london_grafana" {
  providers = {
    aws = aws.london
  }

  source                     = "../../govwifi-grafana"
  env_name                   = local.env_name
  env_subdomain              = local.env_subdomain
  aws_region                 = local.london_aws_region
  critical_notifications_arn = module.london_notifications.topic_arn

  route53_zone_id = data.aws_route53_zone.main.zone_id

  ssh_key_name = var.ssh_key_name

  subnet_ids         = module.london_backend.backend_subnet_ids
  backend_subnet_ids = module.london_backend.backend_subnet_ids
  be_admin_in        = module.london_backend.be_admin_in

  vpc_id = module.london_backend.backend_vpc_id

  bastion_ip = module.london_backend.bastion_public_ip

  administrator_cidrs = var.administrator_cidrs
  prometheus_ips = [
    module.london_prometheus.eip_public_ip,
    module.dublin_prometheus.eip_public_ip
  ]

}

module "london_elasticsearch" {
  providers = {
    aws = aws.london
  }

  source         = "../../govwifi-elasticsearch"
  domain_name    = "${local.env_name}-elasticsearch"
  env_name       = local.env_name
  aws_region     = local.london_aws_region
  aws_account_id = local.aws_account_id
  vpc_id         = module.london_backend.backend_vpc_id
  vpc_cidr_block = module.london_backend.vpc_cidr_block

  backend_subnet_id = module.london_backend.backend_subnet_ids[0]
}

module "london_smoke_tests" {
  providers = {
    aws = aws.london
  }

  source = "../../govwifi-smoke-tests"

  aws_account_id             = local.aws_account_id
  env_subdomain              = local.env_subdomain
  env                        = local.env_name
  smoketests_vpc_cidr        = var.smoketests_vpc_cidr
  smoketest_subnet_private_a = var.smoketest_subnet_private_a
  smoketest_subnet_private_b = var.smoketest_subnet_private_b
  smoketest_subnet_public_a  = var.smoketest_subnet_public_a
  smoketest_subnet_public_b  = var.smoketest_subnet_public_b
  aws_region                 = local.london_aws_region
  create_slack_alert         = 0

}
