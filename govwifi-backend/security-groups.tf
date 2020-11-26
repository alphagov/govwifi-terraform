resource "aws_security_group" "be-ecs-out" {
  name        = "be-ecs-out"
  description = "Allow the ECS agent to talk to the ECS endpoints"
  vpc_id      = "${aws_vpc.wifi-backend.id}"

  tags = {
    Name = "${title(var.Env-Name)} Backend ECS out"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.backend-subnet-IPs)}"]
  }

  egress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.backend-subnet-IPs)}"]
  }
}

resource "aws_security_group" "be-db-in" {
  name        = "be-db-in"
  description = "Allow connections to the DB"
  vpc_id      = "${aws_vpc.wifi-backend.id}"

  tags = {
    Name = "${title(var.Env-Name)} Backend DB in"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.backend-subnet-IPs)}"]
  }
}

resource "aws_security_group" "be-admin-in" {
  name        = "be-admin-in"
  description = "Allow inbound SSH from administrators"
  vpc_id      = "${aws_vpc.wifi-backend.id}"

  tags = {
    Name = "${title(var.Env-Name)} Backend Admin in"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.bastion-server-IP)}", "${split(",", var.backend-subnet-IPs)}"]
  }
}

resource "aws_security_group" "be-vpn-in" {
  name        = "be-vpn-in"
  description = "Allow inbound SSH from VPN IPs to the bastion only"
  vpc_id      = "${aws_vpc.wifi-backend.id}"

  tags = {
    Name = "${title(var.Env-Name)} Backend VPN in"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.administrator-IPs)}"]
  }
}

resource "aws_security_group" "be-vpn-out" {
  name        = "be-vpn-out"
  description = "Allow outbound SSH from bastion"
  vpc_id      = "${aws_vpc.wifi-backend.id}"

  tags = {
    Name = "${title(var.Env-Name)} Backend VPN out"
  }

  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${split(",", var.backend-subnet-IPs)}",
      "${split(",", var.frontend-radius-IPs)}",
      "${var.prometheus-IPs}",
    ]
  }
}

resource "aws_security_group" "be-radius-api-in" {
  name        = "be-radius-api-in"
  description = "Allow inbound API calls from the RADIUS servers"
  vpc_id      = "${aws_vpc.wifi-backend.id}"

  tags = {
    Name = "${title(var.Env-Name)} Backend RADIUS API in"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${split(",",var.frontend-radius-IPs)}"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${split(",",var.frontend-radius-IPs)}"]
  }
}
