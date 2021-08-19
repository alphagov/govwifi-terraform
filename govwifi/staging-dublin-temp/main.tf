provider "aws" {
  # Workaround for import issue, see https://github.com/hashicorp/terraform/issues/13018#issuecomment-291547317
  version = "2.10.0"
  alias   = "AWS-main"
  region  = "${var.aws-region}"
}

provider "aws" {
  version = "2.10.0"
  alias   = "route53-alarms"
  region  = "us-east-1"
}

module "tfstate" {
  providers = {
    aws = aws.AWS-main
  }

  source             = "../../terraform-state"
  product-name       = "${var.product-name}"
  Env-Name           = "${var.Env-Name}"
  aws-account-id     = "${var.aws-account-id}"
  aws-region         = "${var.aws-region}"
  aws-region-name    = "${var.aws-region-name}"
  backup-region-name = "${var.backup-region-name}"

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
}

# Backend ==================================================================
module "backend" {
  providers = {
    aws = aws.AWS-main
  }

  source        = "../../govwifi-backend"
  env           = "staging-temp"
  Env-Name      = "${var.Env-Name}"
  Env-Subdomain = "${var.Env-Subdomain}"

  # AWS VPC setup -----------------------------------------
  aws-region      = "${var.aws-region}"
  route53-zone-id = "${var.route53-zone-id}"
  aws-region-name = "${var.aws-region-name}"
  vpc-cidr-block  = "10.104.0.0/16"
  zone-count      = "${var.zone-count}"
  zone-names      = "${var.zone-names}"

  zone-subnets = {
    zone0 = "10.104.1.0/24"
    zone1 = "10.104.2.0/24"
    zone2 = "10.104.3.0/24"
  }

  backend-subnet-IPs  = "${var.backend-subnet-IPs}"
  administrator-IPs   = "${var.administrator-IPs}"
  bastion-server-IP   = "${var.bastion-server-IP}"
  frontend-radius-IPs = "${var.frontend-radius-IPs}"

  # Instance-specific setup -------------------------------
  # eu-west-1, CIS Ubuntu Linux 16.04 LTS Benchmark v1.0.0.4 - Level 1
  enable-bastion = 0

  # eu-west-2 eu-west-2, CIS Ubuntu Linux 20.04 LTS
  bastion-ami = "ami-08bac620dc84221eb"

  bastion-instance-type     = "t2.micro"
  bastion-server-ip         = "${var.bastion-server-IP}"
  bastion-ssh-key-name      = "staging-temp-bastion-20200717"
  enable-bastion-monitoring = false
  users                     = "${var.users}"
  aws-account-id            = "${var.aws-account-id}"

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
  user-replica-source-db = "arn:aws:rds:eu-west-2:${var.aws-account-id}:db:wifi-staging-temp-user-db"
  user-rr-instance-type  = "db.t2.small"

  user-rr-hostname           = "${var.user-rr-hostname}"
  critical-notifications-arn = "${module.notifications.topic-arn}"
  capacity-notifications-arn = "${module.notifications.topic-arn}"

  # Seconds. Set to zero to disable monitoring
  db-monitoring-interval = 60

  # Passed to application
  db-user               = ""
  db-password           = ""
  user-db-username      = "${var.user-db-username}"
  user-db-password      = "${var.user-db-password}"
  user-db-hostname      = ""
  user-db-instance-type = ""
  user-db-storage-gb    = 0

  rds-kms-key-id = "${var.rds-kms-key-id}"

  prometheus-IP-london  = "${var.prometheus-IP-london}/32"
  prometheus-IP-ireland = "${var.prometheus-IP-ireland}/32"
  grafana-IP            = "${var.grafana-IP}/32"
}

# Emails ======================================================================
# Commenting out because apps are not yet running. SNS subscriptions need to
# be confirmed by an api. As the app is not yet running the subscription check
# will fail. This worked on the old account because the subscription configuration
# was added while the apps were running. COMMENT IN AFTER APPS ARE RUNNING AGAIN

module "emails" {
  providers = {
    aws = aws.AWS-main
  }

  source                   = "../../govwifi-emails"
  product-name             = "${var.product-name}"
  Env-Name                 = "${var.Env-Name}"
  Env-Subdomain            = "${var.Env-Subdomain}"
  aws-account-id           = "${var.aws-account-id}"
  route53-zone-id          = "${var.route53-zone-id}"
  aws-region               = "${var.aws-region}"
  aws-region-name          = "${var.aws-region-name}"
  mail-exchange-server     = "10 inbound-smtp.eu-west-1.amazonaws.com"
  devops-notifications-arn = "${module.notifications.topic-arn}"

  #sns-endpoint             = "https://elb.${lower(var.aws-region-name)}.${var.Env-Subdomain}.service.gov.uk/sns/"
  sns-endpoint                       = "https://api-elb.london.${var.Env-Subdomain}.service.gov.uk/sns/"
  user-signup-notifications-endpoint = "https://user-signup-api.${var.Env-Subdomain}.service.gov.uk:8443/user-signup/email-notification"
}

module "govwifi-keys" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../govwifi-keys"
}

# Frontend ====================================================================
module "frontend" {
  providers = {
    "aws"                = "aws.AWS-main"
    "aws.route53-alarms" = "aws.route53-alarms"
  }

  source        = "../../govwifi-frontend"
  Env-Name      = "${var.Env-Name}"
  Env-Subdomain = "${var.Env-Subdomain}"

  # AWS VPC setup -----------------------------------------
  aws-region          = "${var.aws-region}"
  aws-region-name     = "${var.aws-region-name}"
  route53-zone-id     = "${var.route53-zone-id}"
  vpc-cidr-block      = "10.105.0.0/16"
  zone-count          = "${var.zone-count}"
  zone-names          = "${var.zone-names}"
  rack-env            = "staging"
  sentry-current-env  = "secondary-staging"

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

  elastic-ip-list       = split(",", var.frontend-region-IPs)
  ami                   = "${var.ami}"
  ssh-key-name          = "${var.ssh-key-name}"
  users                 = "${var.users}"
  frontend-docker-image = "${format("%s/frontend:staging", var.docker-image-path)}"
  raddb-docker-image    = "${format("%s/raddb:staging", var.docker-image-path)}"

  # admin bucket
  admin-bucket-name = "govwifi-staging-temp.wifi-admin"

  logging-api-base-url = "${var.london-api-base-url}"
  auth-api-base-url    = "${var.dublin-api-base-url}"

  shared-key = "${var.shared-key}"

  # A site with this radkey must exist in the database for health checks to work
  healthcheck-radius-key = "${var.hc-key}"
  healthcheck-ssid       = "${var.hc-ssid}"
  healthcheck-identity   = "${var.hc-identity}"
  healthcheck-password   = "${var.hc-password}"

  route53-critical-notifications-arn = "${module.route53-notifications.topic-arn}"
  devops-notifications-arn           = "${module.notifications.topic-arn}"

  # Security groups ---------------------------------------
  radius-instance-sg-ids = []

  bastion-ips = [
    "${var.bastion-server-IP}",
  ]

  prometheus-IP-london  = "${var.prometheus-IP-london}/32"
  prometheus-IP-ireland = "${var.prometheus-IP-ireland}/32"

  radius-CIDR-blocks = split(",", var.frontend-radius-IPs)
}

module "api" {
  providers = {
    aws = aws.AWS-main
  }

  source        = "../../govwifi-api"
  env           = "staging"
  Env-Name      = "${var.Stage-Name}"
  Env-Subdomain = "${var.Env-Subdomain}"

  ami                    = ""
  ssh-key-name           = ""
  users                  = []
  backend-elb-count      = 1
  backend-instance-count = 2
  backend-min-size       = 1
  backend-cpualarm-count = 1
  aws-account-id         = "${var.aws-account-id}"
  aws-region-name        = "${var.aws-region-name}"
  aws-region             = "${var.aws-region}"
  route53-zone-id        = "${var.route53-zone-id}"
  vpc-id                 = "${module.backend.backend-vpc-id}"

  user-signup-enabled  = 0
  logging-enabled      = 0
  alarm-count          = 0
  safe-restart-enabled = 0
  event-rule-count     = 0

  critical-notifications-arn = "${module.notifications.topic-arn}"
  capacity-notifications-arn = "${module.notifications.topic-arn}"
  devops-notifications-arn   = "${module.notifications.topic-arn}"

  auth-docker-image         = "${format("%s/authorisation-api:staging", var.docker-image-path)}"
  user-signup-docker-image  = ""
  logging-docker-image      = ""
  safe-restart-docker-image = ""

  background-jobs-enabled = 0

  db-user     = ""
  db-password = ""
  db-hostname = ""

  user-db-username = "${var.user-db-username}"
  user-db-hostname = ""
  user-db-password = "${var.user-db-password}"
  user-rr-hostname = "${var.user-rr-hostname}"

  # There is no read replica for the staging database
  db-read-replica-hostname           = ""
  rack-env                           = "staging"
  sentry-current-env                 = "secondary-staging"
  radius-server-ips                  = "${split(",", var.frontend-radius-IPs)}"
  authentication-sentry-dsn          = "${var.auth-sentry-dsn}"
  safe-restart-sentry-dsn            = ""
  user-signup-sentry-dsn             = ""
  logging-sentry-dsn                 = ""
  shared-key                         = ""
  performance-url                    = ""
  performance-dataset                = ""
  performance-bearer-volumetrics     = ""
  performance-bearer-completion-rate = ""
  performance-bearer-active-users    = ""
  performance-bearer-unique-users    = ""
  subnet-ids                         = "${module.backend.backend-subnet-ids}"
  ecs-instance-profile-id            = "${module.backend.ecs-instance-profile-id}"
  ecs-service-role                   = "${module.backend.ecs-service-role}"
  admin-bucket-name                  = ""

  elb-sg-list = []

  backend-sg-list = [
    "${module.backend.be-admin-in}",
  ]
}

module "notifications" {
  providers = {
    aws = aws.AWS-main
  }

  source = "../../sns-notification"

  env-name   = "${var.Env-Name}"
  topic-name = "govwifi-staging-temp"
  emails     = ["${var.notification-email}"]
}

module "route53-notifications" {
  providers = {
    "aws" = "aws.route53-alarms"
  }

  source = "../../sns-notification"

  env-name   = "${var.Env-Name}"
  topic-name = "govwifi-staging-dublin-temp"
  emails     = ["${var.notification-email}"]
}
