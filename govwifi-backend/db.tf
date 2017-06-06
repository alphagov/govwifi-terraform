resource "aws_db_subnet_group" "db-subnets" {
  name        = "wifi-${var.Env-Name}-subnets"
  description = "GovWifi ${var.Env-Name} backend subnets"
  subnet_ids  = ["${aws_subnet.wifi-backend-subnet.*.id}"]

  tags {
    Name = "wifi-${var.Env-Name}-subnets"
  }
}

resource "aws_db_instance" "db" {
  count                       = "${var.db-instance-count}"
  allocated_storage           = "${var.db-storage-gb}"
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7.16"
  allow_major_version_upgrade = true
  apply_immediately           = true
  instance_class              = "${var.db-instance-type}"
  identifier                  = "wifi-${var.Env-Name}-db"
  name                        = "govwifi_${var.Env-Name}"
  username                    = "${var.db-user}"
  password                    = "${var.db-password}"
  backup_retention_period     = "${var.db-backup-retention-days}"
  multi_az                    = true
  storage_encrypted           = "${var.db-encrypt-at-rest}"
  db_subnet_group_name        = "wifi-${var.Env-Name}-subnets"
  vpc_security_group_ids      = ["${var.db-sg-list}"]
  depends_on                  = ["aws_iam_role.rds-monitoring-role"]
  monitoring_role_arn         = "${aws_iam_role.rds-monitoring-role.arn}"
  monitoring_interval         = "${var.db-monitoring-interval}"
  maintenance_window          = "${var.db-maintenance-window}"
  skip_final_snapshot         = true

  tags {
    Name = "wifi-${var.Env-Name}-db"
  }
}
