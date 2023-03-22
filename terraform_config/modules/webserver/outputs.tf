output "my_ec2_instance" {
  value = aws_instance.my-ec2-instance
}


output "my_ami_id" {
  value = data.aws_ami.my_ami
}
