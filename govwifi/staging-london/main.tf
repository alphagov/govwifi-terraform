module "tfstate" {
  providers = {
    aws = aws.main
  }

  source             = "../../terraform-state"
  product-name       = var.product-name
  Env-Name           = var.Env-Name
  aws-account-id     = local.aws_account_id
  aws-region-name    = var.aws-region-name
  backup-region-name = var.backup-region-name

  # TODO: separate module for accesslogs
  accesslogs-glacier-transition-days = 7
  accesslogs-expiration-days         = 30
}

terraform {
  required_version = "~> 0.15.5"

  backend "s3" {
    # Interpolation is not allowed here.
    #bucket = "${lower(var.product-name)}-${lower(var.Env-Name)}-${lower(var.aws-region-name)}-tfstate"
    #key    = "${lower(var.aws-region-name)}-tfstate"
    #region = "${var.aws-region}"
    bucket = "govwifi-staging-london-tfstate"

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

  create_production_bastion_key = 0
  is_production_aws_account     = var.is_production_aws_account

  govwifi-bastion-key-name = "govwifi-bastion-key-20210630"
  govwifi-bastion-key-pub  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDY/Q676Tp5CTpKWVksMPztERDdjWOrYFgVckF9IHGI2wC38ckWFiqawsEZBILUyNZgL/lnOtheN1UZtuGmUUkPxgtPw+YD6gMDcebhSX4wh9GM3JjXAIy9+V/WagQ84Pz10yIp+PlyzcQMu+RVRVzWyTYZUdgMsDt0tFdcgMgUc7FkC252CgtSZHpLXhnukG5KG69CoTO+kuak/k3vX5jwWjIgfMGZwIAq+F9XSIMAwylCmmdE5MetKl0Wx4EI/fm8WqSZXj+yeFRv9mQTus906AnNieOgOrgt4D24/JuRU1JTlZ35iNbOKcwlOTDSlTQrm4FA1sCllphhD/RQVYpMp6EV3xape626xwkucCC2gYnakxTZFHUIeWfC5aHGrqMOMtXRfW0xs+D+vzo3MCWepdIebWR5KVhqkbNUKHBG9e8oJbTYUkoyBZjC7LtI4fgB3+blXyFVuQoAzjf+poPzdPBfCC9eiUJrEHoOljO9yMcdkBfyW3c/o8Sd9PgNufc= bastion@govwifi"

  govwifi-key-name     = "govwifi-key-20180530"
  govwifi-key-name-pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJmLa/tF941z6Dh/jiZCH6Mw/JoTXGkILim/bgDc3PSBKXFmBwkAFUVgnoOUWJDXvZWpuBJv+vUu+ZlmlszFM00BRXpb4ykRuJxWIjJiNzGlgXW69Satl2e9d37ZtLwlAdABgJyvj10QEiBtB1VS0DBRXK9J+CfwNPnwVnfppFGP86GoqE2Il86t+BB/VC//gKMTttIstyl2nqUwkK3Epq66+1ol3AelmUmBjPiyrmkwp+png9F4B86RqSNa/drfXmUGf1czE4+H+CXqOdje2bmnrwxLQ8GY3MYpz0zTVrB3T1IyXXF6dcdcF6ZId9B/10jMiTigvOeUvraFEf9fK7 govwifi@govwifi"
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
  vpc_cidr_block  = "10.103.0.0/16"
  zone_count      = var.zone-count
  zone_names      = var.zone-names

  zone_subnets = {
    zone0 = "10.103.1.0/24"
    zone1 = "10.103.2.0/24"
    zone2 = "10.103.3.0/24"
  }

  administrator_ips   = var.administrator_ips
  frontend_radius_ips = local.frontend_radius_ips

  # eu-west-2, CIS Ubuntu Linux 16.04 LTS Benchmark v1.0.0.4 - Level 1
  #  bastion-ami                = "ami-ae6d81c9"
  # eu-west-2 eu-west-2, CIS Ubuntu Linux 20.04 LTS
  bastion_ami                = "ami-096cb92bb3580c759"
  bastion_instance_type      = "t2.micro"
  bastion_server_ip          = var.bastion_server_ip
  bastion_ssh_key_name       = "govwifi-staging-bastion-key-20181025"
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
  critical_notifications_arn = ""
  capacity_notifications_arn = ""

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
  backup_mysql_rds = false

  db_storage_alarm_threshold = 19327342936
}

module "govwifi_admin" {
  providers = {
    aws = aws.main
  }

  source                    = "../../govwifi-admin"
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  aws-region      = var.aws-region
  aws-region-name = var.aws-region-name
  vpc-id          = module.backend.backend-vpc-id
  instance-count  = 1

  admin-docker-image   = format("%s/admin:staging", local.docker_image_path)
  rack-env             = "staging"
  sentry-current-env   = "staging"
  ecr-repository-count = 1

  subnet-ids = module.backend.backend-subnet-ids

  db-instance-type         = "db.t2.medium"
  db-storage-gb            = 120
  db-backup-retention-days = 1
  db-encrypt-at-rest       = true
  db-maintenance-window    = "sat:00:42-sat:01:12"
  db-backup-window         = "03:42-04:42"
  db-monitoring-interval   = 60

  rr-db-host = "db.london.staging.wifi.service.gov.uk"
  rr-db-name = "govwifi_staging"

  user-db-host = var.user-db-hostname
  user-db-name = "govwifi_staging_users"

  critical-notifications-arn = ""
  capacity-notifications-arn = ""

  rds-monitoring-role = module.backend.rds-monitoring-role

  london_radius_ip_addresses = var.london_radius_ip_addresses
  dublin_radius_ip_addresses = var.dublin_radius_ip_addresses
  sentry-dsn                 = var.admin_sentry_dsn
  logging-api-search-url     = "https://api-elb.london.${var.Env-Subdomain}.service.gov.uk:8443/logging/authentication/events/search/"
  public-google-api-key      = var.public-google-api-key

  zendesk-api-endpoint = "https://govuk.zendesk.com/api/v2/"
  zendesk_api_user     = var.zendesk_api_user

  bastion_server_ip = var.bastion_server_ip

  use_env_prefix = true

  notification_arn = ""
}

module "api" {
  providers = {
    aws = aws.main
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
  safe-restart-enabled   = 1

  devops-notifications-arn = ""
  notification_arn         = ""

  auth-docker-image             = format("%s/authorisation-api:staging", local.docker_image_path)
  user-signup-docker-image      = format("%s/user-signup-api:staging", local.docker_image_path)
  logging-docker-image          = format("%s/logging-api:staging", local.docker_image_path)
  safe-restart-docker-image     = format("%s/safe-restarter:staging", local.docker_image_path)
  backup-rds-to-s3-docker-image = format("%s/database-backup:staging", local.docker_image_path)

  wordlist-bucket-count = 1
  wordlist-file-path    = "../wordlist-short"
  ecr-repository-count  = 1

  db-hostname = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"

  user-db-hostname = var.user-db-hostname

  user-rr-hostname = var.user-db-hostname

  rack-env                  = "staging"
  sentry-current-env        = "staging"
  radius-server-ips         = local.frontend_radius_ips
  authentication_sentry_dsn = var.auth_sentry_dsn
  safe_restart_sentry_dsn   = var.safe_restart_sentry_dsn
  user_signup_sentry_dsn    = var.user_signup_sentry_dsn
  logging_sentry_dsn        = var.logging_sentry_dsn
  subnet-ids                = module.backend.backend-subnet-ids
  admin-bucket-name         = "govwifi-staging-admin"
  user-signup-api-is-public = 1

  backend-sg-list = [
    module.backend.be-admin-in,
  ]

  metrics-bucket-name = ""

  use_env_prefix   = var.use_env_prefix
  backup_mysql_rds = var.backup_mysql_rds
  rds_mysql_backup_bucket = module.backend.rds_mysql_backup_bucket

  low_cpu_threshold = 0.3
}
