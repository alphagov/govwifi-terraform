resource "aws_elasticache_subnet_group" "cache-subnets" {
  name        = "wifi-${var.Env-Name}-subnets"
  description = "Wifi backend subnets"
  subnet_ids  = ["${aws_subnet.wifi-backend-subnet.*.id}"]
}

resource "aws_elasticache_cluster" "cache" {
  cluster_id             = "${var.Env-Name}-wifi"
  engine                 = "memcached"
  node_type              = "${var.cache-node-type}"
  port                   = 11211
  num_cache_nodes        = 1
  parameter_group_name   = "default.memcached1.4"
  subnet_group_name      = "wifi-${var.Env-Name}-subnets"
  security_group_ids     = ["${var.cache-sg-list}"]
  notification_topic_arn = "${var.capacity-notifications-arn}"
}
