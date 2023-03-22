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

variable "rds_vpc" {

  type        = string
  description = "vpc for the db"

}
