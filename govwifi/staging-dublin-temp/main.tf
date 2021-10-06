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
    bucket = "govwifi-staging-temp-dublin-tfstate"

    key     = "dublin-tfstate"
    encrypt = true
    region  = "eu-west-1"
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
  vpc-cidr-block  = "10.104.0.0/16"
  zone-count      = var.zone-count
  zone-names      = var.zone-names

  zone-subnets = {
    zone0 = "10.104.1.0/24"
    zone1 = "10.104.2.0/24"
    zone2 = "10.104.3.0/24"
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
  bastion-ssh-key-name      = "staging-temp-bastion-20200717"
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

  source = "../../govwifi-emails"

  is_production_aws_account = var.is_production_aws_account
  product-name              = var.product-name
  Env-Name                  = var.Env-Name
  Env-Subdomain             = var.Env-Subdomain
  aws-account-id            = local.aws_account_id
  route53-zone-id           = local.route53_zone_id
  aws-region                = var.aws-region
  aws-region-name           = var.aws-region-name
  mail-exchange-server      = "10 inbound-smtp.eu-west-1.amazonaws.com"
  devops-notifications-arn  = module.notifications.topic-arn

  user-signup-notifications-endpoint = "https://user-signup-api.${var.Env-Subdomain}.service.gov.uk:8443/user-signup/email-notification"

  // The SNS endpoint is disabled in the secondary AWS account
  // We will conduct an SNS inventory (see this card: https://trello.com/c/EMeet3tl/315-investigate-and-inventory-sns-topics)
  sns-endpoint = ""
}

module "govwifi_keys" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../govwifi-keys"

  govwifi-bastion-key-name = "staging-temp-bastion-20200717"
  govwifi-bastion-key-pub  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL5wGVJ8aXL0QUhIvfLV2BMLC9Tk74jnChC40R9ipzK0AuatcaXdj0PEm8sh8sHlXEmdmVDq/4s8XaEkF7MDl38qbjxxHRTpCgcTrYzJGad3xgr1+zhpD8Kfnepex/2pR7z7kOCv7EDx4vRTc8vu1ttcmJiniBmgjc1xVk1A5aB72GxffZrow7B0iopP16vEPvllUjsDoOaeLJukDzsbZaP2RRYBqIA4qXunfJpuuu/o+T+YR4LkTB+9UBOOGrX50T80oTtJMKD9ndQ9CC9sqlrOzE9GiZz9db7D9iOzIZoTT6dBbgEOfCGmkj7WS2NjF+D/pEN/edkIuNGvE+J/HqQ179Xm/VCx5Kr6ARG+xk9cssCQbEFwR46yitaPA7B4mEiyD9XvUW2tUeVKdX5ybUFqV++2c5rxTczuH4gGlEGixIqPeltRvkVrN6qxnrbDAXE2bXymcnEN6BshwGKR+3OUKTS8c53eWmwiol6xwCp8VUI8/66tC/bCTmeur07z2LfQsIo745GzPuinWfUm8yPkZOD3LptkukO1aIfgvuNmlUKTwKSLIIwwsqTZ2FcK39A8g3Iq3HRV+4JwOowLJcylRa3QcSH9wdjd69SqPrZb0RhW0BN1mTX2tEBl1ryUUpKsqpMbvjl28tn6MGsU/sRhBLqliduOukGubD29LlAQ== "

  create_production_bastion_key = 0
  is_production_aws_account     = false

  govwifi-key-name     = var.ssh-key-name
  govwifi-key-name-pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOxYtGJARr+ZUB9wMWMX/H+myTidFKx+qcBsXuri5zavQ6K4c0WhSkypXfET9BBtC1ZU77B98mftegxKdKcKmFbCVlv39pIX+xj2vjuCzHlzezI1vB4mdAXNhc8b4ArvFJ8lG2GLa1ZD8H/8akpv6EcplwyUv6ZgQMPl6wfMF6d0Qe/eOJ/bV570icX9NYLGkdLRbudkRc12krt6h451qp1vO7f2FQOnPR2cnyLGd/FxhrmAOqJsDk9CRNSwHJe1lsSCz6TkQk1bfCTxZ7g2hWSNRBdWPj0RJbbezy3X3/pz4cFL8mCC1esJ+nptUZ7CXeyirtCObIepniXIItwtdIVqixaMSjfagUGd0L1zFEVuH0bct3mh3u3TyVbNHP4o4pFHvG0sm5R1iDB8/xe2NJdxmAsn3JqeXdsQ6uI/oz31OueFRPyZI0VeDw7B4bhBMZ0w/ncrYJ9jFjfPvzhAVZgQX5Pxtp5MUCeU9+xIdAN2bESmIvaoSEwno7WJ4z61d83pLMFUuS9vNRW4ykgd1BzatLYSkLp/fn/wYNn6DBk7Da6Vs1Y/jgkiDJPGeFlEhW3rqOjTKrpKJBw6LBsMyI0BtkKoPoUTDlKSEX5JlNWBX2z5eSEhe+WEQjc4ZnbLUOKRB5+xNOGahVyk7/VF8ZaZ3/GXWY7MEfZ8TIBBcAjw== "

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
  vpc-cidr-block     = "10.105.0.0/16"
  zone-count         = var.zone-count
  zone-names         = var.zone-names
  rack-env           = "staging"
  sentry-current-env = "secondary-staging"

  zone-subnets = {
    zone0 = "10.105.1.0/24"
    zone1 = "10.105.2.0/24"
    zone2 = "10.105.3.0/24"
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
  admin-bucket-name = "govwifi-staging-temp.wifi-admin"

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
  Env-Name                  = "staging"
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
  sentry-current-env        = "secondary-staging"
  radius-server-ips         = local.frontend_radius_ips
  authentication-sentry-dsn = var.auth-sentry-dsn
  safe-restart-sentry-dsn   = ""
  user-signup-sentry-dsn    = ""
  logging-sentry-dsn        = ""
  subnet-ids                = module.backend.backend-subnet-ids
  ecs-instance-profile-id   = module.backend.ecs-instance-profile-id
  ecs-service-role          = module.backend.ecs-service-role
  admin-bucket-name         = ""

  elb-sg-list = []

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
  topic-name = "govwifi-staging-temp"
  emails     = [var.notification-email]
}

module "route53-notifications" {
  providers = {
    aws = aws.route53-alarms
  }

  source = "../../sns-notification"

  env-name   = var.Env-Name
  topic-name = "govwifi-staging-dublin-temp"
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
