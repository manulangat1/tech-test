resource "aws_subnet" "my_rds_subnet" {

  vpc_id     = var.rds_vpc
  cidr_block = "10.0.7.0/24"

  availability_zone = "us-east-1b"
  tags = {
    "Name" = "${var.environment}-dev-s"
  }
  # availability_zone = "us-east-1b"
  # , "us-east-1b" , "us-east-1c" ]
}

resource "aws_subnet" "my_rds_subnet1" {

  vpc_id     = var.rds_vpc
  cidr_block = "10.0.8.0/24"

  availability_zone = "us-east-1a"

  tags = {
    "Name" = "${var.environment}-dev-s1"
  }
  # availability_zone = "us-east-1a"
  # , "us-east-1b" , "us-east-1c" ]
}
