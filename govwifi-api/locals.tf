locals {
  logging_api_namespace       = "${var.Env-Name}-logging-api"
  authorisation_api_namespace = "${var.Env-Name}-authorisation-api"
  signup_api_namespace        = "${var.Env-Name}-user-signup-api"

  scheduled_task_network_configuration = {
    subnets = ["${var.subnet-ids}"]

    security_groups = [
      "${var.backend-sg-list}",
      "${aws_security_group.api-in.id}",
      "${aws_security_group.api-out.id}",
    ]

    assign_public_ip = true
  }
}
