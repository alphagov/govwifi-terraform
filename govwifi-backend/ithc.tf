resource "aws_instance" "ithc" {
  count                  = "${var.ithc-backend-instance-count}"
  ami                    = "${var.ithc-ami}"
  instance_type          = "${var.ithc-instance-type}"
  key_name               = "${var.ithc-ssh-key-name}"
  subnet_id              = "${aws_subnet.wifi-backend-subnet.0.id}"
  vpc_security_group_ids = ["${var.ithc-sg-list}"]
  iam_instance_profile   = "${aws_iam_instance_profile.ithc-instance-profile.id}"
  monitoring             = false

  depends_on = [
    "aws_iam_instance_profile.ithc-instance-profile",
  ]

  tags {
    Name = "${title(var.Env-Name)} ITHC - backend (${aws_vpc.wifi-backend.id})"
  }
}

resource "aws_iam_role" "ithc-instance-role" {
  count = "${var.ithc-backend-instance-count}"
  name  = "${var.aws-region-name}-${var.Env-Name}-backend-ithc-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ithc-instance-policy" {
  count      = "${var.ithc-backend-instance-count}"
  name       = "${var.aws-region-name}-${var.Env-Name}-backend-ithc-instance-policy"
  role       = "${aws_iam_role.ithc-instance-role.id}"
  depends_on = ["aws_iam_role.ithc-instance-role"]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ithc-instance-profile" {
  count      = "${var.ithc-backend-instance-count}"
  name       = "${var.aws-region-name}-${var.Env-Name}-backend-ithc-instance-profile"
  role       = "${aws_iam_role.ithc-instance-role.name}"
  depends_on = ["aws_iam_role.ithc-instance-role"]
}

resource "aws_eip_association" "ithc-eip-assoc" {
  count       = "${var.ithc-backend-instance-count}"
  instance_id = "${aws_instance.ithc.id}"
  public_ip   = "${replace(var.ithc-server-ip, "/32", "")}"
}
