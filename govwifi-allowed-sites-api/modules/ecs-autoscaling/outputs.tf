output "autoscaling.id" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.id}"
}

output "autoscaling.min_size" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.min_size}"
}

output "autoscaling.max_size" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.max_size}"
}

output "autoscaling.default_cooldown" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.default_cooldown}"
}

output "autoscaling.name" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.name}"
}

output "autoscaling.health_check_grace_period" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.health_check_grace_period}"
}

output "autoscaling.health_check_type" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.health_check_type}"
}

output "autoscaling.desired_capacity" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.desired_capacity}"
}

output "autoscaling.launch_configuration" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.launch_configuration}"
}

output "autoscaling.load_balancers" {
  value = "${aws_autoscaling_group.ecs-allowed-sites-api-cluster.load_balancers}"
}

output "launch_configuration.id" {
  value = "${aws_launch_configuration.ecs.id}"
}
