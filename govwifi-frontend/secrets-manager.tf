data "aws_secretsmanager_secret_version" "test" {
  secret_id = data.aws_secretsmanager_secret.test.id
}

data "aws_secretsmanager_secret" "test" {
  name = "staging/radius/test"
}