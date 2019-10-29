resource "aws_vpc_peering_connection" "backend_frontend" {
  peer_vpc_id = "${var.backend_vpc_id}"  # accepter
  vpc_id      = "${var.frontend_vpc_id}" # requester
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

#resource "aws_route" "backend_routes" {
#  route_table_id            = "${var.frontend_route_table_id}"
#  destination_cidr_block    = "${var.destination_cidr_block}"
#  vpc_peering_connection_id = "${aws_vpc_peering_connection.backend_frontend.id}"
#}
