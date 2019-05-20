module "service" {
  source = "../fargate-service"

  stage          = "${var.Env-Name}"
  name           = "admin"
  vpc-id         = "${var.vpc-id}"
  image-tag      = "${var.Env-Name == "wifi" ? "production" : var.Env-Name}"
  subnet-ids     = "${var.subnet-ids}"
  hosted-zone-id = "${data.aws_route53_zone.zone.id}"
  set-subdomain  = "${var.Env-Name != "wifi"}"

  healthcheck-path     = "/healthcheck"
  container-policy-arn = "${aws_iam_policy.ecs-admin-instance-policy.arn}"

  ports = {
    "3000" = "tcp"
  }

  environment = {
    DB_USER                               = "${var.admin-db-user}"
    DB_PASS                               = "${var.admin-db-password}"
    DB_NAME                               = "govwifi_admin_${var.rack-env}"
    DB_HOST                               = "${aws_db_instance.admin_db.address}"
    NOTIFY_API_KEY                        = "${var.notify-api-key}"
    RACK_ENV                              = "${var.rack-env}"
    SECRET_KEY_BASE                       = "${var.secret-key-base}"
    DEVISE_SECRET_KEY                     = "${var.secret-key-base}"
    RAILS_LOG_TO_STDOUT                   = "1"
    RAILS_SERVE_STATIC_FILES              = "1"
    LONDON_RADIUS_IPS                     = "${join(",", var.london-radius-ip-addresses)}"
    DUBLIN_RADIUS_IPS                     = "${join(",", var.dublin-radius-ip-addresses)}"
    SENTRY_DSN                            = "${var.sentry-dsn}"
    S3_MOU_BUCKET                         = "govwifi-${var.rack-env}-admin-mou"
    S3_PUBLISHED_LOCATIONS_IPS_BUCKET     = "govwifi-${var.rack-env}-admin"
    S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY = "ips-and-locations.json"
    S3_SIGNUP_WHITELIST_BUCKET            = "govwifi-${var.rack-env}-admin"
    S3_SIGNUP_WHITELIST_OBJECT_KEY        = "signup-whitelist.conf"
    S3_WHITELIST_OBJECT_KEY               = "clients.conf"
    S3_PRODUCT_PAGE_DATA_BUCKET           = "govwifi-${var.rack-env}-product-page-data"
    S3_ORGANISATION_NAMES_OBJECT_KEY      = "organisations.yml"
    S3_EMAIL_DOMAINS_OBJECT_KEY           = "domains.yml"
    LOGGING_API_SEARCH_ENDPOINT           = "${var.logging-api-search-url}"
    RR_DB_USER                            = "${var.rr-db-user}"
    RR_DB_PASS                            = "${var.rr-db-password}"
    RR_DB_HOST                            = "${var.rr-db-host}"
    RR_DB_NAME                            = "${var.rr-db-name}"
    ZENDESK_API_ENDPOINT                  = "${var.zendesk-api-endpoint}"
    ZENDESK_API_USER                      = "${var.zendesk-api-user}"
    ZENDESK_API_TOKEN                     = "${var.zendesk-api-token}"
    GOOGLE_MAPS_PUBLIC_API_KEY            = "${var.public-google-api-key}"
  }
}
