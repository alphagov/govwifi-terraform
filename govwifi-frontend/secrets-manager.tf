data "aws_secretsmanager_secret_version" "healthcheck" {
  secret_id = data.aws_secretsmanager_secret.healthcheck.id
}

data "aws_secretsmanager_secret" "healthcheck" {
  name = "radius/healthcheck"
}

data "aws_secretsmanager_secret_version" "shared_key" {
  secret_id = data.aws_secretsmanager_secret.shared_key.id
}

data "aws_secretsmanager_secret" "shared_key" {
  name = "radius/shared-key"
}

data "aws_secretsmanager_secret_version" "tools_account" {
  secret_id = data.aws_secretsmanager_secret.tools_account.id
}

data "aws_secretsmanager_secret" "tools_account" {
  name = "tools/AccountID"
}

resource "aws_secretsmanager_secret" "frontend_ips" {
  name = lower("smoke_tests/radius_ips/${var.aws_region_name}")
}

resource "aws_secretsmanager_secret_version" "frontend_ips" {
  secret_id     = aws_secretsmanager_secret.frontend_ips.id
  secret_string = "${aws_eip.radius_eips[0].public_ip},${aws_eip.radius_eips[1].public_ip},${aws_eip.radius_eips[2].public_ip}"
}
