
resource "aws_subnet" "my_subnet" {

  vpc_id     = var.vpc_id
  cidr_block = "10.0.6.0/24"

  tags = {
    "Name" = "${var.environment}-dev"
  }
  availability_zone = var.availability_zone
  # , "us-east-1b" , "us-east-1c" ]
}
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = var.vpc_id

  tags = {
    "Name" = "${var.environment}-gateway"
  }
}


resource "aws_route_table" "my_route_table" {
  vpc_id = var.vpc_id

  # route = [ {
  #   carrier_gateway_id = "value"
  #   cidr_block = "value"
  #   core_network_arn = "value"
  #   destination_prefix_list_id = "value"
  #   egress_only_gateway_id = "value"
  #   gateway_id = m
  #   instance_id = "value"
  #   ipv6_cidr_block = "value"
  #   local_gateway_id = "value"
  #   nat_gateway_id = "value"
  #   network_interface_id = "value"
  #   transit_gateway_id = "value"
  #   vpc_endpoint_id = "value"
  #   vpc_peering_connection_id = "value"
  # } ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }

  tags = {
    "Name" = "${var.environment}-route-table"
  }

}


