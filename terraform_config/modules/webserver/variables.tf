variable "vpc_id" {
  type = string

}

variable "cidr_blocks" {

  type        = string
  description = "This is the cidr block that needs to be defined"

}


variable "availability_zone" {

  type        = string
  description = "This is the availability zone required"
  default     = "us-east-1a"

}


variable "environment" {

  type        = string
  description = " the app environment"


}

variable "sg" {

  type        = string
  description = " the app sg"
}



variable "public_key" {

  type        = string
  description = " the public key"


}


variable "subnet-id" {

  type        = string
  description = "subnet id in use"

}

variable "my-subnet-id" {

  type        = string
  description = "subnet id in use"

}


variable "instance_type" {

  description = "Instance type to be spinned up"

  default = "t2.micro"

}
