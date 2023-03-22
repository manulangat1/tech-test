output "subnet" {

  value = aws_subnet.my_subnet

}


output "route_table_id" {
  value = aws_internet_gateway.my_internet_gateway
}


# output "my_rds_subnet" {

#   value = aws_subnet.my_rds_subnet

# }

# output "my_rds_subnet1" {

#   value = aws_subnet.my_rds_subnet1

# }
