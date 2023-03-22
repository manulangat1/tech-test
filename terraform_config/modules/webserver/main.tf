data "aws_ami" "my_ami" {

  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}





resource "aws_key_pair" "ssh_key" {

  key_name   = "server-key"
  public_key = var.public_key
}

resource "aws_instance" "my-ec2-instance" {

  vpc_security_group_ids = [var.sg]
  ami                    = data.aws_ami.my_ami.id
  instance_type          = var.instance_type

  availability_zone = var.availability_zone

  subnet_id = var.my-subnet-id

  associate_public_ip_address = true

  key_name = aws_key_pair.ssh_key.key_name

  # user_data = <<EOF
  #                 #!/bin/bash
  #                 sudo yum update -y && sudo yum install docker
  #                 sudo systemctl start docker
  #                 sudo usermod -aG docker ec2-user 
  #                 docker run -p 8000:80 nginx
  #             EOF 

  # connection {
  #   type = "ssh"
  # }

  tags = {
    "Name"        = "${var.environment}-server"
    "description" = "This is the server running  the blog cms platform"
  }

}
