resource "aws_eip" "radius-eips" {
  count = var.radius-instance-count
  vpc   = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name   = "${title(var.Env-Name)} Frontend Radius-${var.dns-numbering-base + count.index + 1}"
    Region = title(var.aws-region-name)
    Env    = title(var.Env-Name)
  }
}

