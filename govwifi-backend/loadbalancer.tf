# Create a new load balancer
resource "aws_elb" "backend-elb" {
  count           = "${var.backend-elb-count}"
  name            = "wifi-backend-elb-${var.Env-Name}"
  subnets         = ["${aws_subnet.wifi-backend-subnet.*.id}"]
  security_groups = ["${var.elb-sg-list}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
#    ssl_certificate_id = "${var.elb-ssl-cert-arn}"
  }

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 8443
    lb_protocol        = "https"
#    ssl_certificate_id = "${var.elb-ssl-cert-arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/api/authorize/user/HEALTH/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 2
  connection_draining         = true
  connection_draining_timeout = 30

  tags {
    Name = "backend-elb-${var.Env-Name}"
  }
}
