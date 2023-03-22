variable "environment" {

  type        = string
  description = " the app environment"


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

variable "public_key" {

  description = "this is the public key"

}

variable "instance_type" {

  description = "Instance type to be spinned up"

  default = "t2.micro"

}
