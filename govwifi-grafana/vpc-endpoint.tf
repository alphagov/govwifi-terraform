resource "aws_vpc_endpoint" "vpc-endpoint" {

  policy = data.aws_iam_policy_document.secrets_manager_policy.json

  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.grafana-alb-in.id,
    aws_security_group.grafana-alb-out.id,
    aws_security_group.grafana-ec2-in.id,
    aws_security_group.grafana-ec2-out.id
  ]

  service_name = "com.amazonaws.eu-west-2.secretsmanager"

  subnet_ids = var.backend-subnet-ids

  vpc_endpoint_type = "Interface"

  vpc_id            = var.vpc-id
}