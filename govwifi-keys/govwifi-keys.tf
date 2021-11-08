resource "aws_key_pair" "govwifi_key" {
  key_name   = var.govwifi_key_name
  public_key = var.govwifi_key_name_pub
}
