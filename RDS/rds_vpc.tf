resource "aws_vpc" "rds_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "rds-vpc"
  }
}


resource "aws_internet_gateway" "rds_gateway" {
  vpc_id = aws_vpc.rds_vpc.id

  tags = {
    Name = "rds-internet-gateway"
  }
}


resource "aws_route" "rds_route" {
  route_table_id         = aws_vpc.rds_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.rds_gateway.id
}

resource "aws_subnet" "rds_main" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.rds_vpc.id
  #cidr_block              = "10.0.${count.index}.0/24"
  cidr_block              = "10.0.${length(data.aws_availability_zones.available.names) + count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "rds-public-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "RDS security group"
  vpc_id      = aws_vpc.rds_vpc.id

  # Allow inbound internet access.
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow outbound internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}
