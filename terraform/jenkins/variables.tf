variable "access_key" {}

variable "secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_vpc" {
  default = "vpc-628dae06"
}

variable "aws_subnet" {
  default = {
    east-1a = "subnet-3525fe1f"
    east-1b = "subnet-3832b84e"
    east-1c = "subnet-a71fb2ff"
    east-1e = "subnet-9ab7dfa7"
  }
}

variable "ami" {
  default = {
    centos6 = "ami-1c221e76" 
  }
}

variable "aws_keypair" {
  default = "jeffhallyburton-east-1"
}

variable "aws_user" {
  default = "centos"
}
