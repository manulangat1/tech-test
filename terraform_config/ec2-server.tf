provider "aws" {

}



resource "aws_vpc" "my_vpc" {

  tags = {
    "Name" = "${var.environment}-dev"
  }
  cidr_block = var.cidr_blocks

  #  availability_zone =   var.availability_zone 

}



module "my-subnet" {
  source            = "./modules/subnet"
  cidr_blocks       = var.cidr_blocks
  vpc_id            = aws_vpc.my_vpc.id
  environment       = var.environment
  availability_zone = var.availability_zone
  rds_vpc           = aws_vpc.my_rds_vpc.id

}

resource "aws_route_table_association" "my_route_table_association" {

  subnet_id      = module.my-subnet.subnet.id
  route_table_id = module.my-subnet.route_table_id.id


}
resource "aws_security_group" "my_sg" {

  // here we have the name , ingress for ssh and stuff and the ports that we will be communicating with and eggress
  name = "${var.environment}-security-group"



  vpc_id = aws_vpc.my_vpc.id
  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    to_port     = 8000
    from_port   = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 1338
    from_port   = 1338
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port         = 0
    from_port       = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    "Name" = "${var.environment}-security-group"
  }

}





module "ec2-instance" {

  source            = "./modules/webserver"
  cidr_blocks       = var.cidr_blocks
  vpc_id            = aws_vpc.my_vpc.id
  environment       = var.environment
  availability_zone = var.availability_zone
  my-subnet-id      = module.my-subnet.subnet.id
  subnet-id         = module.my-subnet.subnet.id
  public_key        = var.public_key
  sg                = aws_security_group.my_sg.id
  instance_type     = var.instance_type

}
// create your rds instance here 




resource "aws_vpc" "my_rds_vpc" {
  # name = "education"
  cidr_block = "10.0.0.0/16"
  # azs  = ["us-east-1a", "us-east-1b"]

  # public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

}


module "rds_instance_module" {
  source = "./modules/rds"

  cidr_blocks       = var.cidr_blocks
  vpc_id            = aws_vpc.my_vpc.id
  environment       = var.environment
  availability_zone = var.availability_zone


  rds_vpc = aws_vpc.my_rds_vpc.id
}
resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "my-subnet-groups"
  subnet_ids = [module.rds_instance_module.my_rds_subnet.id, module.rds_instance_module.my_rds_subnet1.id]



  tags = {
    "environment" = "${var.environment}-subnet-group"
  }
}


resource "aws_db_parameter_group" "my_params" {
  name   = "my-db-${var.environment}"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_internet_gateway" "my_rds_gateway" {
  vpc_id = aws_vpc.my_rds_vpc.id

  tags = {
    "Name" = "${var.environment}-gateway-rds"
  }
}


resource "aws_security_group" "my_sg_rds" {

  // here we have the name , ingress for ssh and stuff and the ports that we will be communicating with and eggress
  name = "${var.environment}-security-group-rds"



  vpc_id = aws_vpc.my_rds_vpc.id
  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    to_port     = 8000
    from_port   = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 1338
    from_port   = 1338
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 5432
    from_port   = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port         = 0
    from_port       = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    "Name" = "${var.environment}-security-group"
  }

}


resource "aws_db_instance" "my_db" {

  identifier                 = "my-db-${var.environment}"
  instance_class             = "db.t3.micro"
  allocated_storage          = 5
  engine                     = "postgres"
  engine_version             = "14.1"
  username                   = "postgres"
  password                   = "postgres"
  db_subnet_group_name       = aws_db_subnet_group.my_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.my_sg_rds.id]
  auto_minor_version_upgrade = true
  # publicly_accessible        = true
  publicly_accessible  = true
  parameter_group_name = aws_db_parameter_group.my_params.name
  skip_final_snapshot  = true
}



