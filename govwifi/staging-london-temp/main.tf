module "tfstate" {
  providers = {
    aws = aws.main
  }

  source             = "../../terraform-state"
  product_name       = var.product-name
  env_name           = var.Env-Name
  aws_account_id     = local.aws_account_id
  aws_region_name    = var.aws-region-name
  backup_region_name = var.backup-region-name

  # TODO: separate module for accesslogs
  accesslogs_glacier_transition_days = 7
  accesslogs_expiration_days         = 30
}

terraform {
  required_version = "~> 0.15.5"

  backend "s3" {
    # Interpolation is not allowed here.
    #bucket = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate"
    #key    = "${lower(var.aws-region-name)}-tfstate"
    #region = "${var.aws-region}"
    bucket = "govwifi-staging-temp-london-tfstate"

    key    = "staging-temp-london-tfstate"
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
  region = var.aws-region
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

  govwifi_bastion_key_name = "staging-temp-bastion-20200717"
  govwifi_bastion_key_pub  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL5wGVJ8aXL0QUhIvfLV2BMLC9Tk74jnChC40R9ipzK0AuatcaXdj0PEm8sh8sHlXEmdmVDq/4s8XaEkF7MDl38qbjxxHRTpCgcTrYzJGad3xgr1+zhpD8Kfnepex/2pR7z7kOCv7EDx4vRTc8vu1ttcmJiniBmgjc1xVk1A5aB72GxffZrow7B0iopP16vEPvllUjsDoOaeLJukDzsbZaP2RRYBqIA4qXunfJpuuu/o+T+YR4LkTB+9UBOOGrX50T80oTtJMKD9ndQ9CC9sqlrOzE9GiZz9db7D9iOzIZoTT6dBbgEOfCGmkj7WS2NjF+D/pEN/edkIuNGvE+J/HqQ179Xm/VCx5Kr6ARG+xk9cssCQbEFwR46yitaPA7B4mEiyD9XvUW2tUeVKdX5ybUFqV++2c5rxTczuH4gGlEGixIqPeltRvkVrN6qxnrbDAXE2bXymcnEN6BshwGKR+3OUKTS8c53eWmwiol6xwCp8VUI8/66tC/bCTmeur07z2LfQsIo745GzPuinWfUm8yPkZOD3LptkukO1aIfgvuNmlUKTwKSLIIwwsqTZ2FcK39A8g3Iq3HRV+4JwOowLJcylRa3QcSH9wdjd69SqPrZb0RhW0BN1mTX2tEBl1ryUUpKsqpMbvjl28tn6MGsU/sRhBLqliduOukGubD29LlAQ== "

  create_production_bastion_key = 0

  govwifi_key_name     = var.ssh-key-name
  govwifi_key_name_pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOxYtGJARr+ZUB9wMWMX/H+myTidFKx+qcBsXuri5zavQ6K4c0WhSkypXfET9BBtC1ZU77B98mftegxKdKcKmFbCVlv39pIX+xj2vjuCzHlzezI1vB4mdAXNhc8b4ArvFJ8lG2GLa1ZD8H/8akpv6EcplwyUv6ZgQMPl6wfMF6d0Qe/eOJ/bV570icX9NYLGkdLRbudkRc12krt6h451qp1vO7f2FQOnPR2cnyLGd/FxhrmAOqJsDk9CRNSwHJe1lsSCz6TkQk1bfCTxZ7g2hWSNRBdWPj0RJbbezy3X3/pz4cFL8mCC1esJ+nptUZ7CXeyirtCObIepniXIItwtdIVqixaMSjfagUGd0L1zFEVuH0bct3mh3u3TyVbNHP4o4pFHvG0sm5R1iDB8/xe2NJdxmAsn3JqeXdsQ6uI/oz31OueFRPyZI0VeDw7B4bhBMZ0w/ncrYJ9jFjfPvzhAVZgQX5Pxtp5MUCeU9+xIdAN2bESmIvaoSEwno7WJ4z61d83pLMFUuS9vNRW4ykgd1BzatLYSkLp/fn/wYNn6DBk7Da6Vs1Y/jgkiDJPGeFlEhW3rqOjTKrpKJBw6LBsMyI0BtkKoPoUTDlKSEX5JlNWBX2z5eSEhe+WEQjc4ZnbLUOKRB5+xNOGahVyk7/VF8ZaZ3/GXWY7MEfZ8TIBBcAjw== GovWifi-DevOps@digital.cabinet-office.gov.uk"

}

# London Backend ==================================================================
module "backend" {
  providers = {
    aws = aws.main
    # Instance-specific setup -------------------------------
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
  vpc_cidr_block  = "10.106.0.0/16"
  zone_count      = var.zone-count
  zone_names      = var.zone-names

  zone_subnets = {
    zone0 = "10.106.1.0/24"
    zone1 = "10.106.2.0/24"
    zone2 = "10.106.3.0/24"
  }

  administrator_ips   = var.administrator_ips
  frontend_radius_ips = local.frontend_radius_ips

  # eu-west-2, CIS Ubuntu Linux 16.04 LTS Benchmark v1.0.0.4 - Level 1
  #  bastion-ami                = "ami-ae6d81c9"
  # eu-west-2 eu-west-2, CIS Ubuntu Linux 20.04 LTS
  bastion_ami                = "ami-096cb92bb3580c759"
  bastion_instance_type      = "t2.micro"
  bastion_server_ip          = var.bastion_server_ip
  bastion_ssh_key_name       = "staging-temp-bastion-20200717"
  enable_bastion_monitoring  = false
  users                      = var.users
  aws_account_id             = local.aws_account_id
  db_instance_count          = 1
  session_db_instance_type   = "db.t2.small"
  session_db_storage_gb      = 20
  db_backup_retention_days   = 1
  db_encrypt_at_rest         = true
  db_maintenance_window      = "sat:01:42-sat:02:12"
  db_backup_window           = "04:42-05:42"
  db_replica_count           = 0
  rr_instance_type           = "db.t2.large"
  rr_storage_gb              = 200
  user_rr_hostname           = var.user-rr-hostname
  critical_notifications_arn = module.notifications.topic-arn
  capacity_notifications_arn = module.notifications.topic-arn

  # Seconds. Set to zero to disable monitoring
  db_monitoring_interval = 60

  # Passed to application
  user_db_hostname      = var.user-db-hostname
  user_db_instance_type = "db.t2.small"
  user_db_storage_gb    = 20

  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland
  grafana_ip            = var.grafana_ip

  use_env_prefix   = var.use_env_prefix
  backup_mysql_rds = var.backup_mysql_rds

  db_storage_alarm_threshold = 19327342936
}

# London Frontend ==================================================================
module "frontend" {
  providers = {
    aws           = aws.main
    aws.us_east_1 = aws.us_east_1
  }

  source                    = "../../govwifi-frontend"
  env_name                  = var.Env-Name
  env_subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  # AWS VPC setup -----------------------------------------
  # LONDON
  aws_region = var.aws-region

  aws_region_name    = var.aws-region-name
  route53_zone_id    = local.route53_zone_id
  vpc_cidr_block     = "10.102.0.0/16"
  zone_count         = var.zone-count
  zone_names         = var.zone-names
  rack_env           = "staging"
  sentry_current_env = "secondary-staging"

  zone_subnets = {
    zone0 = "10.102.1.0/24"
    zone1 = "10.102.2.0/24"
    zone2 = "10.102.3.0/24"
  }

  # Instance-specific setup -------------------------------
  radius_instance_count      = 3
  enable_detailed_monitoring = false

  # eg. dns records are generated for radius(N).x.service.gov.uk
  # where N = this base + 1 + server#
  dns_numbering_base = 3

  elastic_ip_list       = local.frontend_region_ips
  ami                   = var.ami
  ssh_key_name          = var.ssh-key-name
  frontend_docker_image = format("%s/frontend:staging", local.docker_image_path)
  raddb_docker_image    = format("%s/raddb:staging", local.docker_image_path)
  create_ecr            = 1

  admin_app_data_s3_bucket_name = module.govwifi_admin.app_data_s3_bucket_name

  logging_api_base_url = var.london-api-base-url
  auth_api_base_url    = var.london-api-base-url

  critical_notifications_arn           = module.notifications.topic-arn
  us_east_1_critical_notifications_arn = module.route53-notifications.topic-arn

  bastion_server_ip = var.bastion_server_ip

  prometheus_ip_london  = var.prometheus_ip_london
  prometheus_ip_ireland = var.prometheus_ip_ireland

  radius_cidr_blocks = [for ip in local.frontend_radius_ips : "${ip}/32"]

  use_env_prefix = var.use_env_prefix

}

module "govwifi_admin" {
  providers = {
    aws = aws.main
  }

  source                    = "../../govwifi-admin"
  env_name                  = var.Env-Name
  env_subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  aws_region      = var.aws-region
  aws_region_name = var.aws-region-name
  vpc_id          = module.backend.backend-vpc-id
  instance_count  = 1

  admin_docker_image   = format("%s/admin:staging", local.docker_image_path)
  rack_env             = "staging"
  sentry_current_env   = "secondary-staging"
  ecr_repository_count = 1

  subnet_ids = module.backend.backend-subnet-ids

  db_instance_type         = "db.t2.medium"
  db_storage_gb            = 120
  db_backup_retention_days = 1
  db_encrypt_at_rest       = true
  db_maintenance_window    = "sat:00:42-sat:01:12"
  db_backup_window         = "03:42-04:42"
  db_monitoring_interval   = 60

  rr_db_host = "db.london.staging-temp.wifi.service.gov.uk"
  rr_db_name = "govwifi_staging"

  user_db_host = var.user-db-hostname
  user_db_name = "govwifi_staging_users"

  critical_notifications_arn = module.notifications.topic-arn
  capacity_notifications_arn = module.notifications.topic-arn

  rds_monitoring_role = module.backend.rds-monitoring-role

  london_radius_ip_addresses = var.london_radius_ip_addresses
  dublin_radius_ip_addresses = var.dublin_radius_ip_addresses
  sentry_dsn                 = var.admin_sentry_dsn
  logging_api_search_url     = "https://api-elb.london.${var.Env-Subdomain}.service.gov.uk:8443/logging/authentication/events/search/"
  public_google_api_key      = var.public-google-api-key

  zendesk_api_endpoint = "https://govuk.zendesk.com/api/v2/"
  zendesk_api_user     = var.zendesk_api_user

  bastion_server_ip = var.bastion_server_ip

  use_env_prefix = var.use_env_prefix

  notification_arn = module.notifications.topic-arn
}

module "api" {
  providers = {
    aws = aws.main
  }

  source                    = "../../govwifi-api"
  env                       = "staging"
  env_name                  = "staging"
  env_subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  backend_elb_count      = 1
  backend_instance_count = 2
  aws_account_id         = local.aws_account_id
  aws_region_name        = var.aws-region-name
  aws_region             = var.aws-region
  route53_zone_id        = local.route53_zone_id
  vpc_id                 = module.backend.backend-vpc-id
  safe_restart_enabled   = 1

  devops_notifications_arn = module.notifications.topic-arn
  notification_arn         = module.notifications.topic-arn

  auth_docker_image             = format("%s/authorisation-api:staging", local.docker_image_path)
  user_signup_docker_image      = format("%s/user-signup-api:staging", local.docker_image_path)
  logging_docker_image          = format("%s/logging-api:staging", local.docker_image_path)
  safe_restart_docker_image     = format("%s/safe-restarter:staging", local.docker_image_path)
  backup_rds_to_s3_docker_image = format("%s/database-backup:staging", local.docker_image_path)

  wordlist_bucket_count = 1
  wordlist_file_path    = "../wordlist-short"
  ecr_repository_count  = 1

  db_hostname = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"

  user_db_hostname = var.user-db-hostname

  user_rr_hostname = var.user-db-hostname

  rack_env                  = "staging"
  sentry_current_env        = "secondary-staging"
  radius_server_ips         = local.frontend_radius_ips
  authentication_sentry_dsn = var.auth_sentry_dsn
  safe_restart_sentry_dsn   = var.safe_restart_sentry_dsn
  user_signup_sentry_dsn    = var.user_signup_sentry_dsn
  logging_sentry_dsn        = var.logging_sentry_dsn
  subnet_ids                = module.backend.backend-subnet-ids
  user_signup_api_is_public = 1

  admin_app_data_s3_bucket_name = module.govwifi_admin.app_data_s3_bucket_name

  backend_sg_list = [
    module.backend.be-admin-in,
  ]

  metrics_bucket_name     = module.govwifi_dashboard.metrics-bucket-name
  export_data_bucket_name = module.govwifi_dashboard.export-data-bucket-name

  use_env_prefix          = var.use_env_prefix
  rds_mysql_backup_bucket = module.backend.rds_mysql_backup_bucket
  backup_mysql_rds        = var.backup_mysql_rds

  low_cpu_threshold = 0.3

}

module "notifications" {
  providers = {
    aws = aws.main
  }

  source = "../../sns-notification"

  topic_name = "govwifi-staging-temp"
  emails     = [var.notification_email]
}

module "route53-notifications" {
  providers = {
    aws = aws.us_east_1
  }

  source = "../../sns-notification"

  topic_name = "govwifi-staging-london-temp"
  emails     = [var.notification_email]
}

module "govwifi_dashboard" {
  providers = {
    aws = aws.main
  }

  source   = "../../govwifi-dashboard"
  env_name = var.Env-Name
}

/*
We are only configuring a Prometheus server in Staging London for now, although
in production the instance is available in both regions.
The server will scrape metrics from the agents configured in both regions.
There are some problems with the Staging Bastion instance that is preventing
us from mirroring the setup in Production in Staging. This will be rectified
when we create a separate staging environment.
*/
module "govwifi_prometheus" {
  providers = {
    aws = aws.main
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

  london_radius_ip_addresses = var.london_radius_ip_addresses
  dublin_radius_ip_addresses = var.dublin_radius_ip_addresses

  prometheus_ip = var.prometheus_ip_london
  grafana_ip    = var.grafana_ip
}

module "govwifi_grafana" {
  providers = {
    aws = aws.main
  }

  source                     = "../../govwifi-grafana"
  env_name                   = var.Env-Name
  env_subdomain              = var.Env-Subdomain
  aws_region                 = var.aws-region
  critical_notifications_arn = module.notifications.topic-arn
  is_production_aws_account  = var.is_production_aws_account


  ssh_key_name = var.ssh-key-name

  subnet_ids         = module.backend.backend-subnet-ids
  backend_subnet_ids = module.backend.backend-subnet-ids
  be_admin_in        = module.backend.be-admin-in

  vpc_id = module.backend.backend-vpc-id

  bastion_ip = var.bastion_server_ip

  administrator_ips = var.administrator_ips
  prometheus_ips = [
    var.prometheus_ip_london,
    var.prometheus_ip_ireland
  ]

  use_env_prefix = var.use_env_prefix
}

module "govwifi_elasticsearch" {
  providers = {
    aws = aws.main
  }

  source         = "../../govwifi-elasticsearch"
  domain_name    = "${var.Env-Name}-elasticsearch"
  env_name       = var.Env-Name
  aws_region     = var.aws-region
  aws_account_id = local.aws_account_id
  vpc_id         = module.backend.backend-vpc-id
  vpc_cidr_block = module.backend.vpc-cidr-block

  backend_subnet_id = module.backend.backend-subnet-ids[0]
}

module "govwifi_datasync" {
  providers = {
    aws = aws.us_east_1
  }
  source = "../../govwifi-datasync"

  aws_region = var.aws-region
  rack_env   = "staging"
}
