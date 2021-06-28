variable "region" {
  default       = "ap-northeast-1"
  description   = "AWS Regin"
}

variable "vpc_cidr" {
  default       = "10.0.0.0/16"
  description   = "VPC CIDR Block"
}

variable "public_subnet_1a_cidr" {
  description = "Public Subnet 1a CIDR"
}

variable "public_subnet_1c_cidr" {
  description = "Public Subnet 1c CIDR"
}

variable "private_subnet_2a_cidr" {
  description = "Private Subnet 2a CIDR"
}

variable "private_subnet_2c_cidr" {
  description = "Private Subnet 2c CIDR"
}