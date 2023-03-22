output "my_ami_id" {
  value = module.ec2-instance.my_ami_id.id

}


output "my_ec2_instance" {

  value = module.ec2-instance.my_ec2_instance.public_ip

}


output "my_rds_instance" {

  value = aws_db_instance.my_db.endpoint
}
