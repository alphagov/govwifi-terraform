resource "aws_vpc_endpoint" "vpc_endpoint" {

  policy = data.aws_iam_policy_document.secrets_manager_policy.json

  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.grafana_alb_in.id,
    aws_security_group.grafana_alb_out.id,
    aws_security_group.grafana_ec2_in.id,
    aws_security_group.grafana_ec2_out.id
  ]

  service_name = "com.amazonaws.eu-west-2.secretsmanager"

  subnet_ids = var.backend_subnet_ids

  vpc_endpoint_type = "Interface"

  vpc_id = var.vpc_id
}
