resource "aws_key_pair" "govwifi_key" {
  key_name   = var.govwifi-key-name
  public_key = var.govwifi-key-name-pub
}
