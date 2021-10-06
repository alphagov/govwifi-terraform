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
    bucket = "govwifi-staging-london-tfstate"

    key    = "london-tfstate"
    region = "eu-west-2"
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
    aws = aws.AWS-main
    # Instance-specific setup -------------------------------
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
  vpc-cidr-block  = "10.103.0.0/16"
  zone-count      = var.zone-count
  zone-names      = var.zone-names

  zone-subnets = {
    zone0 = "10.103.1.0/24"
    zone1 = "10.103.2.0/24"
    zone2 = "10.103.3.0/24"
  }

  administrator-IPs   = var.administrator-IPs
  frontend-radius-IPs = local.frontend_radius_ips

  # eu-west-2, CIS Ubuntu Linux 16.04 LTS Benchmark v1.0.0.4 - Level 1
  #  bastion-ami                = "ami-ae6d81c9"
  # eu-west-2 eu-west-2, CIS Ubuntu Linux 20.04 LTS
  bastion-ami                = "ami-096cb92bb3580c759"
  bastion-instance-type      = "t2.micro"
  bastion-server-ip          = split("/", var.bastion-server-IP)[0]
  bastion-ssh-key-name       = "govwifi-staging-bastion-key-20181025"
  enable-bastion-monitoring  = false
  users                      = var.users
  aws-account-id             = local.aws_account_id
  db-instance-count          = 1
  session-db-instance-type   = "db.t2.small"
  session-db-storage-gb      = 20
  db-backup-retention-days   = 1
  db-encrypt-at-rest         = true
  db-maintenance-window      = "sat:01:42-sat:02:12"
  db-backup-window           = "04:42-05:42"
  db-replica-count           = 0
  rr-instance-type           = "db.t2.large"
  rr-storage-gb              = 200
  user-rr-hostname           = var.user-rr-hostname
  critical-notifications-arn = module.notifications.topic-arn
  capacity-notifications-arn = module.notifications.topic-arn

  # Seconds. Set to zero to disable monitoring
  db-monitoring-interval = 60

  # Passed to application
  user-db-hostname      = var.user-db-hostname
  user-db-instance-type = "db.t2.small"
  user-db-storage-gb    = 20

  prometheus-IP-london  = "${var.prometheus-IP-london}/32"
  prometheus-IP-ireland = "${var.prometheus-IP-ireland}/32"
  grafana-IP            = "${var.grafana-IP}/32"

  use_env_prefix   = var.use_env_prefix
  backup_mysql_rds = var.backup_mysql_rds

  db-storage-alarm-threshold = 19327342936
}

# London Frontend ==================================================================
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
  # LONDON
  aws-region = var.aws-region

  aws-region-name    = var.aws-region-name
  route53-zone-id    = local.route53_zone_id
  vpc-cidr-block     = "10.102.0.0/16"
  zone-count         = var.zone-count
  zone-names         = var.zone-names
  rack-env           = "staging"
  sentry-current-env = "staging"

  zone-subnets = {
    zone0 = "10.102.1.0/24"
    zone1 = "10.102.2.0/24"
    zone2 = "10.102.3.0/24"
  }

  # Instance-specific setup -------------------------------
  radius-instance-count      = 3
  enable-detailed-monitoring = false

  # eg. dns records are generated for radius(N).x.service.gov.uk
  # where N = this base + 1 + server#
  dns-numbering-base = 3

  elastic-ip-list       = local.frontend_region_ips
  ami                   = var.ami
  ssh-key-name          = var.ssh-key-name
  users                 = var.users
  frontend-docker-image = format("%s/frontend:staging", local.docker_image_path)
  raddb-docker-image    = format("%s/raddb:staging", local.docker_image_path)
  create-ecr            = 1

  # admin bucket
  admin-bucket-name = "govwifi-staging-admin"

  logging-api-base-url = var.london-api-base-url
  auth-api-base-url    = var.london-api-base-url

  # This must be based on us-east-1, as that's where the alarms go
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

  critical-notifications-arn = module.notifications.topic-arn
  capacity-notifications-arn = module.notifications.topic-arn

  rds-monitoring-role = module.backend.rds-monitoring-role

  london-radius-ip-addresses = var.london-radius-ip-addresses
  dublin-radius-ip-addresses = var.dublin-radius-ip-addresses
  sentry-dsn                 = var.admin-sentry-dsn
  logging-api-search-url     = "https://api-elb.london.${var.Env-Subdomain}.service.gov.uk:8443/logging/authentication/events/search/"
  public-google-api-key      = var.public-google-api-key

  zendesk-api-endpoint = "https://govuk.zendesk.com/api/v2/"
  zendesk-api-user     = var.zendesk-api-user

  bastion_server_ip = split("/", var.bastion-server-IP)[0]

  use_env_prefix = true

  notification_arn = module.notifications.topic-arn
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
  iam-count              = 1
  safe-restart-enabled   = 1

  devops-notifications-arn = module.notifications.topic-arn
  notification_arn         = module.notifications.topic-arn

  auth-docker-image             = format("%s/authorisation-api:staging", local.docker_image_path)
  user-signup-docker-image      = format("%s/user-signup-api:staging", local.docker_image_path)
  logging-docker-image          = format("%s/logging-api:staging", local.docker_image_path)
  safe-restart-docker-image     = format("%s/safe-restarter:staging", local.docker_image_path)
  backup-rds-to-s3-docker-image = format("%s/database-backup:staging", local.docker_image_path)

  wordlist-bucket-count   = 1
  wordlist-file-path      = "../wordlist-short"
  ecr-repository-count    = 1
  background-jobs-enabled = 1

  db-hostname = "db.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk"

  user-db-hostname = var.user-db-hostname

  user-rr-hostname = var.user-db-hostname

  rack-env                  = "staging"
  sentry-current-env        = "staging"
  radius-server-ips         = local.frontend_radius_ips
  authentication-sentry-dsn = var.auth-sentry-dsn
  safe-restart-sentry-dsn   = var.safe-restart-sentry-dsn
  user-signup-sentry-dsn    = var.user-signup-sentry-dsn
  logging-sentry-dsn        = var.logging-sentry-dsn
  subnet-ids                = module.backend.backend-subnet-ids
  admin-bucket-name         = "govwifi-staging-admin"
  user-signup-api-is-public = 1

  backend-sg-list = [
    module.backend.be-admin-in,
  ]

  metrics-bucket-name = module.govwifi_dashboard.metrics-bucket-name

  use_env_prefix   = var.use_env_prefix
  backup_mysql_rds = var.backup_mysql_rds

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
  topic-name = "govwifi-staging-london"
  emails     = [var.notification-email]
}

module "govwifi_dashboard" {
  providers = {
    aws = aws.AWS-main
  }

  source   = "../../govwifi-dashboard"
  Env-Name = var.Env-Name
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
  # Value defaults to 0 and is only enabled (i.e., value = 1) in staging-london
  create_prometheus_server = 1

  prometheus-IP = var.prometheus-IP-london
  grafana-IP    = "${var.grafana-IP}/32"
}

module "govwifi_grafana" {
  providers = {
    aws = aws.AWS-main
  }

  source                     = "../../govwifi-grafana"
  Env-Name                   = var.Env-Name
  Env-Subdomain              = var.Env-Subdomain
  aws-region                 = var.aws-region
  critical-notifications-arn = module.notifications.topic-arn
  is_production_aws_account  = var.is_production_aws_account

  ssh-key-name = var.ssh-key-name

  subnet-ids = module.backend.backend-subnet-ids

  backend-subnet-ids = module.backend.backend-subnet-ids

  be-admin-in = module.backend.be-admin-in

  # Feature toggle so we only create the Grafana instance in Staging London
  create_grafana_server = "1"

  vpc-id = module.backend.backend-vpc-id

  # The value of bastion-server-IP isn't actually an IP address, but a
  # /32 CIDR block, extract the IP address from CIDR block here before
  # passing it on.
  bastion_ip = split("/", var.bastion-server-IP)[0]

  administrator-IPs = var.administrator-IPs

  prometheus-IPs = concat(
    split(",", "${var.prometheus-IP-london}/32"),
    split(",", "${var.prometheus-IP-ireland}/32")
  )

  use_env_prefix = var.use_env_prefix
}

module "govwifi_elasticsearch" {
  providers = {
    aws = aws.AWS-main
  }

  source         = "../../govwifi-elasticsearch"
  domain-name    = "${var.Env-Name}-elasticsearch"
  Env-Name       = var.Env-Name
  Env-Subdomain  = var.Env-Subdomain
  aws-region     = var.aws-region
  aws-account-id = local.aws_account_id
  vpc-id         = module.backend.backend-vpc-id
  vpc-cidr-block = module.backend.vpc-cidr-block

  backend-subnet-id = module.backend.backend-subnet-ids[0]
}
