provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "production-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags {
    Name = "Production-VPC"
  }
}

resource "aws_subnet" "public-subnet-1a" {
  cidr_block        = var.public_subnet_1a_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "ap-northeast-1a"

  tags {
    Name = "Public-Subnet-1a"
  }
}

resource "aws_subnet" "public-subnet-1c" {
  cidr_block        = var.public_subnet_1c_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "ap-northeast-1c"

  tags {
    Name = "Public-Subnet-1c"
  }
}

resource "aws_subnet" "private-subnet-2a" {
  cidr_block        = var.private_subnet_2a_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "ap-northeast-1a"

  tags {
    Name = "Private-Subnet-2a"
  }
}

resource "aws_subnet" "private-subnet-2c" {
  cidr_block        = var.private_subnet_2c_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "ap-northeast-1c"

  tags {
    Name = "Private-Subnet-2c"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production-vpc.id
  tags {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production-vpc.id
  tags {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table_association" "public-route-table-1a-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1a.id
}

resource "aws_route_table_association" "public-route-table-1c-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1c.id
}

resource "aws_route_table_association" "private-route-2a-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2a.id
}

resource "aws_route_table_association" "private-route-2c-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2c.id
}

resource "aws_eip" "elastic-ip-for-nat-gw-1a" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"
  tags {
    Name = "Production-EIP-1a"
  }
}

# resource "aws_eip" "elastic-ip-for-nat-gw-1c" {
#   vpc                       = true
#   associate_with_private_ip = "10.0.0.6"
#   tags {
#     Name = "Production-EIP-1c"
#   }
# }

resource "aws_nat_gateway" "nat-gw-1a" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw-1a.id
  subnet_id     = aws_subnet.public-subnet-1a.id

  tags {
    Name = "Production-NAT-GW-1a"
  }
  depends_on = ["aws_eip.elastic-ip-for-nat-gw-1a"]
}

# resource "aws_nat_gateway" "nat-gw-1c" {
#   allocation_id = "${aws_eip.elastic-ip-for-nat-gw-1c.id}"
#   subnet_id     = "${aws_subnet.public-subnet-1c.id}"
#
#   tags {
#     Name = "Production-NAT-GW-1c"
#   }
#
#   depends_on    = ["aws_eip.elastic-ip-for-nat-gw-1c"]
# }

resource "aws_route" "nat-gw-route" {
  route_table_id        = aws_route_table.private-route-table.id
  nat_gateway_id        = aws_nat_gateway.nat-gw-1a.id
  destination_cidrblock = "0.0.0.0/0"
}

resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production-vpc.id
  tags {
    Name = "Production-IGW"
  }
}

resource "aws_route" "public-internet-gw-route" {
  route_table_id        = aws_route_table.public-route-table.id
  gateway_id            = aws_internet_gateway.production-igw.id
  destination_cidrblock = "0.0.0.0/0"
}
