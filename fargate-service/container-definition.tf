locals {
  container-definition-environment-keys = "${keys(var.environment)}"
  container-definition-ports            = "${keys(var.ports)}"
}

data "template_file" "container-definition-environment" {
  count = "${length(local.container-definition-environment-keys)}"

  vars = {
    name  = "${element(local.container-definition-environment-keys, count.index)}"
    value = "${var.environment[element(local.container-definition-environment-keys, count.index)]}"
  }

  template = <<EOT
    $${jsonencode(map(
      "name", name,
      "value", value
    ))}
EOT
}

data "template_file" "container-definition-ports" {
  count = "${local.container-definition-ports}"

  vars = {
    port     = "${element(local.container-definition-ports, count.index)}"
    protocol = "${var.ports[element(local.container-definition-ports, count.index)]}"
  }

  template = <<EOT
    $${jsonencode(map(
      "containerPort", port,
      "protocol", protocol
    ))}
EOT
}

data "template_file" "container-definition" {
  template = <<EOT
[
    {
      "portMappings": $${jsonencode(data.template_file.container-definition-ports.*.rendered)},
      "essential": true,
      "name": "${var.name}",
      "environment": $${jsonencode(data.template_file.container-definition-environment.*.rendered)},
      "image": "${local.image}",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
          "awslogs-region": "${data.aws_region.current.name}",
          "awslogs-stream-prefix": "${local.full-name}"
        }
      }
    }
]
EOT
}
