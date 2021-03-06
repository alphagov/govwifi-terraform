data "aws_secretsmanager_secret_version" "aws_account_id" {
  secret_id = data.aws_secretsmanager_secret.aws_account_id.id
}

data "aws_secretsmanager_secret" "aws_account_id" {
  name = var.use_env_prefix ? "staging/aws/account-id" : "aws/account-id"
}

data "aws_secretsmanager_secret_version" "docker_image_path" {
  secret_id = data.aws_secretsmanager_secret.docker_image_path.id
}

data "aws_secretsmanager_secret" "docker_image_path" {
  name = var.use_env_prefix ? "staging/aws/ecr/docker-image-path/govwifi" : "aws/ecr/docker-image-path/govwifi"
}

data "aws_secretsmanager_secret_version" "route53_zone_id" {
  secret_id = data.aws_secretsmanager_secret.route53_zone_id.id
}

data "aws_secretsmanager_secret" "route53_zone_id" {
  name = var.use_env_prefix ? "staging/aws/route53/zone-id" : "aws/route53/zone-id"
}