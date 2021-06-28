provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "production-vpc" {
  cidr_block            = "${var.vpc_cidr}"
  enable_dns_hostnames  = true

  tags {
    Name = "Production-VPC"
  }
}

resource "aws_subnet" "public-subnet-1a" {
  cidr_block          = "${var.public_subnet_1a_cidr}"
  vpc_id              = "${aws_vpc.production-vpc.id}"
  availability_zone   = "ap-northeast-1a"

  tags {
    Name = "Public-Subnet-1a"
  }
}

resource "aws_subnet" "public-subnet-1c" {
  cidr_block          = "${var.public_subnet_1c_cidr}"
  vpc_id              = "${aws_vpc.production-vpc.id}"
  availability_zone   = "ap-northeast-1c"

  tags {
    Name = "Public-Subnet-1c"
  }
}

resource "aws_subnet" "private-subnet-2a" {
  cidr_block          = "${var.private_subnet_2a_cidr}"
  vpc_id              = "${aws_vpc.production-vpc.id}"
  availability_zone   = "ap-northeast-1a"

  tags {
    Name = "Private-Subnet-2a"
  }
}

resource "aws_subnet" "private-subnet-2c" {
  cidr_block          = "${var.private_subnet_2c_cidr}"
  vpc_id              = "${aws_vpc.production-vpc.id}"
  availability_zone   = "ap-northeast-1c"

  tags {
    Name = "Private-Subnet-2c"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id              = "${aws_vpc.production-vpc.id}"
  tags {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id              = "${aws_vpc.production-vpc.id}"
  tags {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table_association" "public-route-table-1a-association" {
  route_table_id      = "${aws_route_table.public-route-table.id}"
  subnet_id           = "${aws_subnet.public-subnet-1a.id}"
}

resource "aws_route_table_association" "public-route-table-1c-association" {
  route_table_id      = "${aws_route_table.public-route-table.id}"
  subnet_id           = "${aws_subnet.public-subnet-1c.id}"
}

resource "aws_route_table_association" "private-route-2a-association" {
  route_table_id      = "${aws_route_table.private-route-table.id}"
  subnet_id           = "${aws_subnet.private-subnet-2a.id}"
}

resource "aws_route_table_association" "private-route-2c-association" {
  route_table_id      = "${aws_route_table.private-route-table.id}"
  subnet_id           = "${aws_subnet.private-subnet-2c.id}"
}