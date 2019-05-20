resource "aws_security_group" "admin-db-in" {
  name        = "admin-db-in"
  description = "Allow connections to the DB"
  vpc_id      = "${var.vpc-id}"

  tags {
    Name = "${title(var.Env-Name)} Admin DB in"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.backend_subnet.*.cidr_block}"]
  }
}

data "aws_subnet" "backend_subnet" {
  count = "${length(var.subnet-ids)}"
  id    = "${var.subnet-ids[count.index]}"
}
