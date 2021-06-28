output "vpc_id" {
  value = aws_vpc.production-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.production-vpc.cidr_block
}

output "public-subnet-1a_id" {
  value = aws_subnet.public-subnet-1a.id
}

output "public-subnet-1c_id" {
  value = aws_subnet.public-subnet-1c.id
}

output "private-subnet-2a_id" {
  value = aws_subnet.private-subnet-2a.id
}

output "private-subnet-2c_id" {
  value = aws_subnet.private-subnet-2c.id
}

# output "private_subnets" {
#   value = list(aws_subnet.private-subnet-2a.id, aws_subnet.private-subnet-2c.id)
# }
#
# output "public_subnets" {
#   value = list(aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1c.id)
# }
