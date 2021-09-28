resource "aws_key_pair" "govwifi_key" {
  key_name   = var.govwifi-key-name
  public_key = var.govwifi-key-name-pub
}

resource "aws_key_pair" "govwifi_staging_key" {
  count      = var.is_production_aws_account ? 1 : 0
  key_name   = "govwifi-staging-key-20180530"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jsytL0L7huY13GeWQiQJ3ak0y5D3fhZDWaIlkF5nrrplxuURqFutmV4d1qN7ZxxwKedx5lKZOMC6OsqFDZVifzGCv9lkfvGusNsiRfDqQZGcMfZgwUbTO7jwFDcat5rjgKjKGcx7q5YZb74diHITbIarY74WAK6xvvLgRE9UbcmHv216ifnyu0gEJ0SKzIcgXHJsfDX4lImRwpL2Pz992TbaSvKDN8Ueev3LFCZzYrLbqgrP9YtUDmucEVPGf6g0MUdaJYpZ0UlfEzLohVlumwADrA5dJ0uz7FejiZFZPJDHQcaHJMmwwf5GIJO+jhgfPQMNN467QdRzAp7EC+kd staging@govwifi"
}
