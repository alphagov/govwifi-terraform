resource "aws_eip" "grafana_staging" {
  instance = "${aws_instance.grafana_instance.id}"
  vpc      = true
}

resource "aws_eip_association" "grafana_eip_assoc" {
  count       = "${var.create_grafana_server}"
  depends_on  = ["aws_instance.grafana_instance"]
  instance_id = "${aws_instance.grafana_instance.id}"
  allocation_id = "${aws_eip.grafana_staging.id}"
}