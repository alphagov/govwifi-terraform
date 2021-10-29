resource "aws_key_pair" "govwifi_bastion_key" {
  count      = var.create_production_bastion_key
  key_name   = var.govwifi-bastion-key-name
  public_key = var.govwifi-bastion-key-pub
}
