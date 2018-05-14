resource "aws_elb" "allowed-sites-api-elb" {
  count           = "${var.backend-elb-count}"
  name            = "allowed-sites-api-elb-${var.Env-Name}"
  subnets         = ["${var.subnet-ids}"]
  security_groups = ["${var.elb-sg-list}"]

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.elb-ssl-cert-arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 2
  connection_draining         = true
  connection_draining_timeout = 30

  tags {
    Name = "allowed-sites-api-elb-${var.Env-Name}"
  }
}
