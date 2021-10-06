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
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  is_production_aws_account = var.is_production_aws_account

  # AWS VPC setup -----------------------------------------
  aws-region      = var.aws-region
  route53-zone-id = local.route53_zone_id
  aws-region-name = var.aws-region-name
  vpc-cidr-block  = "10.100.0.0/16"
  zone-count      = var.zone-count
  zone-names      = var.zone-names

  zone-subnets = {
    zone0 = "10.100.1.0/24"
    zone1 = "10.100.2.0/24"
    zone2 = "10.100.3.0/24"
  }

  administrator-IPs   = var.administrator-IPs
  frontend-radius-IPs = local.frontend_radius_ips

  # Instance-specific setup -------------------------------
  # eu-west-1, CIS Ubuntu Linux 16.04 LTS Benchmark v1.0.0.4 - Level 1
  enable-bastion = 0
  #bastion-ami = "ami-51d3e928"
  # eu-west-2 eu-west-2, CIS Ubuntu Linux 20.04 LTS
  bastion-ami = "ami-08bac620dc84221eb"

  bastion-instance-type     = "t2.micro"
  bastion-server-ip         = split("/", var.bastion-server-IP)[0]
  bastion-ssh-key-name      = "govwifi-staging-bastion-key-20181025"
  enable-bastion-monitoring = false
  users                     = var.users
  aws-account-id            = local.aws_account_id

  db-encrypt-at-rest       = true
  db-maintenance-window    = "sat:00:42-sat:01:12"
  db-backup-window         = "03:42-04:42"
  db-backup-retention-days = 1

  db-instance-count        = 0
  session-db-instance-type = ""
  session-db-storage-gb    = 0

  db-replica-count = 0
  rr-instance-type = ""
  rr-storage-gb    = 0

  user-db-replica-count  = 1
  user-replica-source-db = "arn:aws:rds:eu-west-2:${local.aws_account_id}:db:wifi-staging-user-db"
  user-rr-instance-type  = "db.t2.small"

  user-rr-hostname           = var.user-rr-hostname
  critical-notifications-arn = module.notifications.topic-arn
  capacity-notifications-arn = module.notifications.topic-arn

  # Seconds. Set to zero to disable monitoring
  db-monitoring-interval = 60

  # Passed to application
  user-db-hostname      = ""
  user-db-instance-type = ""
  user-db-storage-gb    = 0
  prometheus-IP-london  = "${var.prometheus-IP-london}/32"
  prometheus-IP-ireland = "${var.prometheus-IP-ireland}/32"
  grafana-IP            = "${var.grafana-IP}/32"

  use_env_prefix = var.use_env_prefix

  db-storage-alarm-threshold = 19327342936
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
  users                 = var.users
  frontend-docker-image = format("%s/frontend:staging", local.docker_image_path)
  raddb-docker-image    = format("%s/raddb:staging", local.docker_image_path)

  # admin bucket
  admin-bucket-name = "govwifi-staging-admin"

  logging-api-base-url = var.london-api-base-url
  auth-api-base-url    = var.dublin-api-base-url

  route53-critical-notifications-arn = module.route53-notifications.topic-arn
  devops-notifications-arn           = module.notifications.topic-arn

  # Security groups ---------------------------------------
  radius-instance-sg-ids = []

  bastion_server_ip = split("/", var.bastion-server-IP)[0]

  prometheus-IP-london  = "${var.prometheus-IP-london}/32"
  prometheus-IP-ireland = "${var.prometheus-IP-ireland}/32"

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

  ami                    = ""
  ssh-key-name           = ""
  users                  = []
  backend-elb-count      = 1
  backend-instance-count = 2
  backend-min-size       = 1
  backend-cpualarm-count = 1
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

  critical-notifications-arn = module.notifications.topic-arn
  capacity-notifications-arn = module.notifications.topic-arn
  devops-notifications-arn   = module.notifications.topic-arn
  notification_arn           = module.notifications.topic-arn

  auth-docker-image             = format("%s/authorisation-api:staging", local.docker_image_path)
  user-signup-docker-image      = ""
  logging-docker-image          = ""
  safe-restart-docker-image     = ""
  backup-rds-to-s3-docker-image = ""

  background-jobs-enabled = 0

  db-hostname = ""

  user-db-hostname = ""
  user-rr-hostname = var.user-rr-hostname

  # There is no read replica for the staging database
  db-read-replica-hostname  = ""
  rack-env                  = "staging"
  sentry-current-env        = "staging"
  radius-server-ips         = local.frontend_radius_ips
  authentication-sentry-dsn = var.auth-sentry-dsn
  safe-restart-sentry-dsn   = ""
  user-signup-sentry-dsn    = ""
  logging-sentry-dsn        = ""
  subnet-ids                = module.backend.backend-subnet-ids
  ecs-instance-profile-id   = module.backend.ecs-instance-profile-id
  ecs-service-role          = module.backend.ecs-service-role
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

  env-name   = var.Env-Name
  topic-name = "govwifi-staging"
  emails     = [var.notification-email]
}

module "route53-notifications" {
  providers = {
    aws = aws.route53-alarms
  }

  source = "../../sns-notification"

  env-name   = var.Env-Name
  topic-name = "govwifi-staging"
  emails     = [var.notification-email]
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
  london-radius-ip-addresses = var.london-radius-ip-addresses
  dublin-radius-ip-addresses = var.dublin-radius-ip-addresses

  # Feature toggle creating Prometheus server.
  # Value defaults to 0 and should only be enabled (i.e., value = 1)
  create_prometheus_server = 0

  prometheus-IP = var.prometheus-IP-ireland
  grafana-IP    = "${var.grafana-IP}/32"
}
