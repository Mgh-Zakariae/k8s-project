resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "app-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "app-vpc-public-subnet-eu-north-1a"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "app-vpc-private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "app-vpc-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "app-vpc-rtb-public"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "app-vpc-rtb-private${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}