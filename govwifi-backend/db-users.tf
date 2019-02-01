resource "aws_db_instance" "users_db" {
  count                       = "${var.db-instance-count}"
  allocated_storage           = "${var.user-db-storage-gb}"
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "8.0.11"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = true
  instance_class              = "${var.user-db-instance-type}"
  identifier                  = "wifi-${var.env}-user-db"
  name                        = "govwifi_${var.env}_users"
  username                    = "${var.user-db-username}"
  password                    = "${var.user-db-password}"
  backup_retention_period     = "${var.db-backup-retention-days}"
  multi_az                    = true
  storage_encrypted           = "${var.db-encrypt-at-rest}"
  db_subnet_group_name        = "wifi-${var.Env-Name}-subnets"
  vpc_security_group_ids      = ["${var.db-sg-list}"]
  depends_on                  = ["aws_iam_role.rds-monitoring-role"]
  monitoring_role_arn         = "${aws_iam_role.rds-monitoring-role.arn}"
  monitoring_interval         = "${var.db-monitoring-interval}"
  maintenance_window          = "${var.db-maintenance-window}"
  backup_window               = "${var.db-backup-window}"
  skip_final_snapshot         = true

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  option_group_name               = "${aws_db_option_group.user-mariadb-audit.name}"
  parameter_group_name            = "${aws_db_parameter_group.user-db-parameters.name}"

  tags {
    Name = "${title(var.env)} Users DB"
  }
}
