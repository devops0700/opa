# VPC
resource "aws_vpc" "momenton_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "momentonVPC"
    Environment = "development"
  }
}

# Subnets : public
resource "aws_subnet" "private" {
  count             = length(var.subnets_cidr)
  vpc_id            = aws_vpc.momenton_vpc.id
  cidr_block        = element(var.subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name   = "momentonVPC-Subnet-${count.index + 1}"
    Access = "private"
  }
}
