locals {
  london_aws_region             = "eu-west-2"
  london_aws_region_name        = "London"
  london_backend_vpc_cidr_block = "10.106.0.0/16"
}

provider "aws" {
  alias  = "london"
  region = local.london_aws_region

  default_tags {
    tags = {
      Environment = title(local.env_name)
    }
  }
  /* As tags are computed, terraform always thinks have checked, re: issue https://github.com/hashicorp/terraform-provider-aws/issues/18311#issuecomment-1544330448 */
  ignore_tags {
    keys = ["Environment", "Staging"]
  }
}

module "london_keys" {
  providers = {
    aws = aws.london
  }

  source = "../../govwifi-keys"

  govwifi_bastion_key_name = "staging-bastion-20200717"
  govwifi_bastion_key_pub  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL5wGVJ8aXL0QUhIvfLV2BMLC9Tk74jnChC40R9ipzK0AuatcaXdj0PEm8sh8sHlXEmdmVDq/4s8XaEkF7MDl38qbjxxHRTpCgcTrYzJGad3xgr1+zhpD8Kfnepex/2pR7z7kOCv7EDx4vRTc8vu1ttcmJiniBmgjc1xVk1A5aB72GxffZrow7B0iopP16vEPvllUjsDoOaeLJukDzsbZaP2RRYBqIA4qXunfJpuuu/o+T+YR4LkTB+9UBOOGrX50T80oTtJMKD9ndQ9CC9sqlrOzE9GiZz9db7D9iOzIZoTT6dBbgEOfCGmkj7WS2NjF+D/pEN/edkIuNGvE+J/HqQ179Xm/VCx5Kr6ARG+xk9cssCQbEFwR46yitaPA7B4mEiyD9XvUW2tUeVKdX5ybUFqV++2c5rxTczuH4gGlEGixIqPeltRvkVrN6qxnrbDAXE2bXymcnEN6BshwGKR+3OUKTS8c53eWmwiol6xwCp8VUI8/66tC/bCTmeur07z2LfQsIo745GzPuinWfUm8yPkZOD3LptkukO1aIfgvuNmlUKTwKSLIIwwsqTZ2FcK39A8g3Iq3HRV+4JwOowLJcylRa3QcSH9wdjd69SqPrZb0RhW0BN1mTX2tEBl1ryUUpKsqpMbvjl28tn6MGsU/sRhBLqliduOukGubD29LlAQ== "

  create_production_bastion_key = 0

  govwifi_key_name     = var.ssh_key_name
  govwifi_key_name_pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOxYtGJARr+ZUB9wMWMX/H+myTidFKx+qcBsXuri5zavQ6K4c0WhSkypXfET9BBtC1ZU77B98mftegxKdKcKmFbCVlv39pIX+xj2vjuCzHlzezI1vB4mdAXNhc8b4ArvFJ8lG2GLa1ZD8H/8akpv6EcplwyUv6ZgQMPl6wfMF6d0Qe/eOJ/bV570icX9NYLGkdLRbudkRc12krt6h451qp1vO7f2FQOnPR2cnyLGd/FxhrmAOqJsDk9CRNSwHJe1lsSCz6TkQk1bfCTxZ7g2hWSNRBdWPj0RJbbezy3X3/pz4cFL8mCC1esJ+nptUZ7CXeyirtCObIepniXIItwtdIVqixaMSjfagUGd0L1zFEVuH0bct3mh3u3TyVbNHP4o4pFHvG0sm5R1iDB8/xe2NJdxmAsn3JqeXdsQ6uI/oz31OueFRPyZI0VeDw7B4bhBMZ0w/ncrYJ9jFjfPvzhAVZgQX5Pxtp5MUCeU9+xIdAN2bESmIvaoSEwno7WJ4z61d83pLMFUuS9vNRW4ykgd1BzatLYSkLp/fn/wYNn6DBk7Da6Vs1Y/jgkiDJPGeFlEhW3rqOjTKrpKJBw6LBsMyI0BtkKoPoUTDlKSEX5JlNWBX2z5eSEhe+WEQjc4ZnbLUOKRB5+xNOGahVyk7/VF8ZaZ3/GXWY7MEfZ8TIBBcAjw== GovWifi-DevOps@digital.cabinet-office.gov.uk"

}

module "london_backend" {
  providers = {
    aws = aws.london
  }

  source        = "../../govwifi-backend"
  env           = "staging"
  env_name      = local.env_name
  env_subdomain = local.env_subdomain

  # AWS VPC setup -----------------------------------------
  aws_region      = local.london_aws_region
  route53_zone_id = data.aws_route53_zone.main.zone_id
  aws_region_name = local.london_aws_region_name
  vpc_cidr_block  = local.london_backend_vpc_cidr_block

  administrator_cidrs = var.administrator_cidrs
  frontend_radius_ips = local.frontend_radius_ips

  bastion_instance_type     = "t2.micro"
  bastion_ssh_key_name      = "staging-bastion-20200717"
  enable_bastion_monitoring = false
  aws_account_id            = local.aws_account_id
  db_instance_count         = 1
  session_db_instance_type  = "db.t3.small"
  session_db_storage_gb     = 20
  db_backup_retention_days  = 1
  db_encrypt_at_rest        = true
  db_maintenance_window     = "sat:01:42-sat:02:12"
  db_backup_window          = "04:42-05:42"
  db_replica_count          = 0
  rr_instance_type          = "db.t3.large"
  rr_storage_gb             = 200
  # TODO This should happen inside the module
  user_rr_hostname           = "users-rr.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  critical_notifications_arn = module.london_critical_notifications.topic_arn
  capacity_notifications_arn = module.london_notifications.topic_arn

  # Seconds. Set to zero to disable monitoring
  db_monitoring_interval = 60

  # Passed to application
  # TODO This should happen inside the module
  user_db_hostname      = "users-db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  user_db_instance_type = "db.t3.small"
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

  source         = "../../govwifi-frontend"
  env_name       = local.env_name
  env_subdomain  = local.env_subdomain
  env            = local.env
  aws_account_id = local.aws_account_id

  # AWS VPC setup -----------------------------------------
  # LONDON
  aws_region = local.london_aws_region

  aws_region_name    = local.london_aws_region_name
  route53_zone_id    = data.aws_route53_zone.main.zone_id
  vpc_cidr_block     = "10.102.0.0/16"
  rack_env           = "staging"
  sentry_current_env = "staging"

  backend_vpc_id = module.london_backend.backend_vpc_id

  # Instance-specific setup -------------------------------
  radius_instance_count      = 3
  enable_detailed_monitoring = false

  # eg. dns records are generated for radius(N).x.service.gov.uk
  # where N = this base + 1 + server#
  dns_numbering_base = 3

  ami                   = "ami-2218f945"
  ssh_key_name          = var.ssh_key_name
  frontend_docker_image = format("%s/frontend:staging", local.docker_image_path)
  raddb_docker_image    = format("%s/raddb:staging", local.docker_image_path)
  create_ecr            = 1

  admin_app_data_s3_bucket_name = module.london_admin.app_data_s3_bucket_name

  logging_api_base_url = module.london_api.api_base_url
  auth_api_base_url    = module.london_api.api_base_url

  authentication_api_internal_dns_name = module.london_api.authentication_api_internal_dns_name
  logging_api_internal_dns_name        = one(module.london_api.logging_api_internal_dns_name)

  pagerduty_notifications_arn = module.london_notifications.topic_arn
  critical_notifications_arn  = module.london_critical_notifications.topic_arn

  bastion_server_ip = module.london_backend.bastion_public_ip

  prometheus_ip_london  = module.london_prometheus.eip_public_ip
  prometheus_ip_ireland = module.london_prometheus.eip_public_ip

  prometheus_security_group_id = module.london_prometheus.prometheus_security_group_id

  radius_cidr_blocks = [for ip in local.frontend_radius_ips : "${ip}/32"]

  london_backend_vpc_cidr = module.london_backend.vpc_cidr_block
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

  admin_docker_image   = format("%s/admin:staging", local.docker_image_path)
  rails_env            = "production"
  app_env              = "staging"
  sentry_current_env   = "staging"
  ecr_repository_count = 1

  subnet_ids = module.london_backend.backend_subnet_ids

  db_instance_type         = "db.t3.medium"
  db_storage_gb            = 120
  db_backup_retention_days = 1
  db_encrypt_at_rest       = true
  db_maintenance_window    = "sat:00:42-sat:01:12"
  db_backup_window         = "03:42-04:42"
  db_monitoring_interval   = 60

  rr_db_host = "db.london.staging.wifi.service.gov.uk"
  rr_db_name = "govwifi_staging"

  user_db_host = "users-db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  user_db_name = "govwifi_staging_users"

  critical_notifications_arn = module.london_critical_notifications.topic_arn
  capacity_notifications_arn = module.london_notifications.topic_arn

  rds_monitoring_role = module.london_backend.rds_monitoring_role

  london_radius_ip_addresses = module.london_frontend.eip_public_ips
  dublin_radius_ip_addresses = module.dublin_frontend.eip_public_ips
  logging_api_search_url     = "https://api-elb.london.${local.env_subdomain}.service.gov.uk:8443/logging/authentication/events/search/"
  public_google_api_key      = var.public_google_api_key

  zendesk_api_endpoint = "https://govuk.zendesk.com/api/v2/"
  zendesk_api_user     = var.zendesk_api_user

  bastion_server_ip = module.london_backend.bastion_public_ip

  pagerduty_notifications_arn = module.london_notifications.topic_arn

  elasticsearch_endpoint = module.london_elasticsearch.endpoint

  frontend_cert_bucket     = module.london_frontend.frontend_certs_bucket_name
  trusted_certificates_key = module.london_frontend.trusted_certificates_key
}

module "london_api" {
  providers = {
    aws = aws.london
  }

  source        = "../../govwifi-api"
  env           = "staging"
  env_name      = "staging"
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

  capacity_notifications_arn  = module.london_notifications.topic_arn
  devops_notifications_arn    = module.london_notifications.topic_arn
  pagerduty_notifications_arn = module.london_notifications.topic_arn
  critical_notifications_arn  = module.london_critical_notifications.topic_arn

  user_signup_docker_image      = format("%s/user-signup-api:staging", local.docker_image_path)
  logging_docker_image          = format("%s/logging-api:staging", local.docker_image_path)
  safe_restart_docker_image     = format("%s/safe-restarter:staging", local.docker_image_path)
  backup_rds_to_s3_docker_image = format("%s/database-backup:staging", local.docker_image_path)

  create_wordlist_bucket = true
  wordlist_file_path     = "../wordlist-short"
  ecr_repository_count   = 1

  db_hostname = "db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"

  user_db_hostname = "users-db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"
  user_rr_hostname = "users-db.${lower(local.london_aws_region_name)}.${local.env_subdomain}.service.gov.uk"

  rack_env                  = "staging"
  app_env                   = "staging"
  sentry_current_env        = "staging"
  radius_server_ips         = local.frontend_radius_ips
  subnet_ids                = module.london_backend.backend_subnet_ids
  private_subnet_ids        = module.london_backend.backend_private_subnet_ids
  nat_gateway_elastic_ips   = module.london_backend.nat_gateway_elastic_ips
  notify_ips                = var.notify_ips
  user_signup_api_is_public = 1

  admin_app_data_s3_bucket_name = module.london_admin.app_data_s3_bucket_name

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
  smoke_test_ips         = module.london_smoke_tests.eip_public_ips
}

module "london_route53_notifications" {
  providers = {
    aws = aws.us_east_1
  }

  source = "../../sns-notification"

  topic_name = "govwifi-staging-london"
  emails     = [var.notification_email]
}

module "london_notifications" {
  providers = {
    aws = aws.london
  }

  source = "../../sns-notification"

  topic_name = "govwifi-staging-london-capacity"
  emails     = [var.notification_email]
}

module "london_critical_notifications" {
  providers = {
    aws = aws.london
  }

  source = "../../sns-notification"

  topic_name = "govwifi-staging-london-critical"
  emails     = [var.notification_email]
}

module "govwifi_slack_alerts" {
  providers = {
    aws = aws.london
  }

  source = "../../govwifi-slack-alerts"

  london_critical_notifications_topic_arn = module.london_critical_notifications.topic_arn
  london_capacity_notifications_topic_arn = module.london_notifications.topic_arn
  dublin_critical_notifications_topic_arn = module.dublin_critical_notifications.topic_arn
  dublin_capacity_notifications_topic_arn = module.dublin_notifications.topic_arn

  route53_critical_notifications_topic_arn = module.london_route53_notifications.topic_arn
  # set to 1 to create config for slack chat bot.
  create_slack_alert = 0
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

  source          = "../../govwifi-prometheus"
  env_name        = local.env_name
  aws_region      = local.london_aws_region
  aws_region_name = local.london_aws_region_name
  aws_account_id  = local.aws_account_id


  ssh_key_name = var.ssh_key_name

  frontend_vpc_id = module.london_frontend.frontend_vpc_id

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
  aws_region_name            = local.london_aws_region_name
  capacity_notifications_arn = module.london_notifications.topic_arn

  route53_zone_id = data.aws_route53_zone.main.zone_id

  ssh_key_name = var.ssh_key_name

  subnet_ids         = module.london_backend.backend_subnet_ids
  backend_subnet_ids = module.london_backend.backend_subnet_ids

  vpc_id = module.london_backend.backend_vpc_id

  bastion_ip = module.london_backend.bastion_public_ip

  administrator_cidrs = var.administrator_cidrs
  prometheus_ips = [
    module.london_prometheus.eip_public_ip,
    module.dublin_prometheus.eip_public_ip
  ]
  aws_account_id    = local.aws_account_id
  vpc_be_cidr_block = local.london_backend_vpc_cidr_block
}

module "london_govwifi-ecs-update-service" {
  providers = {
    aws = aws.london
  }

  source = "../../govwifi-ecs-update-service"

  deployed_app_names = ["user-signup-api", "logging-api", "admin", "authentication-api"]

  env_name = "staging"

  aws_account_id = local.aws_account_id
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
    aws        = aws.london
    aws.dublin = aws.dublin
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
  govwifi_phone_number       = "+447537417039"
  notify_field               = "govwifistaging"

  depends_on = [
    module.london_frontend
  ]
}

module "london_sync_certs" {
  providers = {
    aws = aws.london
  }

  source = "../../govwifi-sync-certs"

  env            = local.env
  aws_account_id = local.aws_account_id
  aws_region     = local.london_aws_region
  region_name    = local.london_aws_region_name
}

module "london_account_policy" {
  providers = {
    aws = aws.london
  }

  source = "../../govwifi-account-policy"

  aws_region     = local.london_aws_region
  env            = local.env
  aws_account_id = local.aws_account_id
  region_name    = local.london_aws_region_name

}

