resource "aws_lb" "main" {
  name               = "frontend"
  load_balancer_type = "network"

  enable_cross_zone_load_balancing = true

  dynamic "subnet_mapping" {
    for_each = [for subnet in aws_subnet.wifi_frontend_subnet : subnet.id]
    iterator = subnet_id

    content {
      subnet_id     = subnet_id.value
      allocation_id = aws_eip.test_radius_eips[subnet_id.key].id
    }
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "1812"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name        = "frontend"
  port        = 1812
  protocol    = "UDP"
  vpc_id      = aws_vpc.wifi_frontend.id
  target_type = "ip"

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = 3000

    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# TODO These EIPs are being used to test the network load balancer,
# and can be replaced by the radius_eips once the network load
# balancer is used behind these eips
resource "aws_eip" "test_radius_eips" {
  count = var.radius_instance_count
  vpc   = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name   = "${title(var.env_name)} Frontend Radius-${var.dns_numbering_base + count.index + 1}"
    Region = title(var.aws_region_name)
    Env    = title(var.env_name)
  }
}
